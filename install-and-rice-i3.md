# Install, Customize and Rice i3 on Linux Mint 19

## Install

Install i3 and some helpers/tools with:

```
sudo apt install i3 i3lock i3status dunst suckless-tools vim
```

For a flawless experience on HiDPI/Retina displays, run:

```
cat <<EOT >> $HOME/.Xresources

# A Flawless i3wm experience on a HiDPI/Retina display
# https://dougie.io/linux/hidpi-retina-i3wm/
Xft.dpi: 192
Xft.autohint: 0
Xft.lcdfilter:  lcddefault
Xft.hintstyle:  hintfull
Xft.hinting: 1
Xft.antialias: 1
Xft.rgba: rgb
EOT
```

and:

```
cat <<EOT >> $HOME/.profile

# A Flawless i3wm experience on a HiDPI/Retina display
# https://dougie.io/linux/hidpi-retina-i3wm/
export GDK_SCALE=2
export GDK_DPI_SCALE=0.5
export QT_AUTO_SCREEN_SCALE_FACTOR=1
EOT
```

Log out, select i3 as your window manager and log back in.

Hit `Enter` to generate a sample config file, then choose your `Mod` key.

## Customize

Configuration files live in `~/.i3/` or `~/.config/i3/` depending on your distribution, for example `~/.i3/config` or `~/.config/i3/config`.

If you selected **No** upon first launch, use `i3-config-wizard` to generate a default config file.

Then make your life easier by defining local environment variables pointing to the config folder and config file with:

```
I3_CONFIG_FOLDER=~/.config/i3
I3_CONFIG_FILE=$I3_CONFIG_FOLDER/config
```

### Bind a key to i3lock

```bash
cat <<EOT >> $I3_CONFIG_FILE

# Lock screen with Mod+Shift+x
bindsym $mod+shift+x exec i3lock
EOT
```

Refer to the full i3 documentation at https://i3wm.org/ for more details.

Take changes into effect by restarting i3 with `Mod+Shift+r`.

### Add support for multimedia keys

Add support for multimedia keys with:

```bash
cat <<EOT >> $I3_CONFIG_FILE

# Multimedia Keys
# ---
# Pulse Audio controls
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume 0 +5% # increase sound volume
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume 0 -5% # decrease sound volume
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute 0 toggle # mute sound

# Screen brightness controls
bindsym XF86MonBrightnessUp exec xbacklight -inc 20 # increase screen brightness
bindsym XF86MonBrightnessDown exec xbacklight -dec 20 # decrease screen brightness

# Media player controls
bindsym XF86AudioPlay exec playerctl play
bindsym XF86AudioPause exec playerctl pause
bindsym XF86AudioNext exec playerctl next
bindsym XF86AudioPrev exec playerctl previous
EOT
```

Note that `pactl` might installed by default on Ubuntu. However `playerctl` might not. You need to install it from https://github.com/altdesktop/playerctl/releases:

```
curl -sLO https://github.com/altdesktop/playerctl/releases/download/v2.0.2/playerctl-2.0.2_amd64.deb
sudo dpkg -i playerctl-2.0.2_amd64.deb
```

Reference: https://faq.i3wm.org/question/3747/enabling-multimedia-keys/?answer=3759#post-id-3759

### Run application(s) on startup

Load Rhythmbox automatically with:

```
cat <<EOT >> $I3_CONFIG_FILE

# Run on startup
exec rhythmbox
EOT
```

Log out and log back it to test, as `Mod+Shift+r` is not enough here. Use `exec_always` to run applications on configuration reloads too.

### Use custom wallpaper

Save your wallpaper as `~/Pictures/wallpaper.jpg`, then install `feh` with `sudo apt install -y feh`.

Set the wallpaper with:

```
cat <<EOT >> $I3_CONFIG_FILE

# Set wallpaper (even when reloading i3 config)
# --bg-scale fits the file into the background without repeating it, cutting off
# stuff or using borders. The aspect ratio is not preserved, as opposed to
# --bg-fill.
exec_always feh --bg-scale $HOME/Pictures/wallpaper.jpg
EOT
```

### Configure monitors

Use `arandr` on top of `xrandr` to configure monitors and changre resolution/orientation.

```
sudo apt install -y arandr
```

Run `arandr` from a terminal or the dmenu. Experiment with settings. When you are happy with your changes, click **Save As** to save the generated  `xrandr` command to a local file. Append the generated command to your i3 config file to make sure the monitor is configured on startup. For example, on a MacBook Pro 13" Retina with a 2560x1600 screen:

```
cat <<EOT >> $I3_CONFIG_FILE

# Configure monitor(s)
exec_always xrandr --output HDMI-2 --off --output HDMI-1 --off --output DP-1 --off --output eDP-1 --primary --mode 2560x1600 --pos 0x0 --rotate normal --output DP-2 --off
EOT
```

### Configure workspaces

Workspaces can be renamed from **1**, **2**, **3** to anything. For example:

```
bindsym $mod+1 workspace Terminals
```

Then you can update the binding used to move windows to workspace 1 with:

```
bindsym $mod+Shift+1 move container to workspace Terminals
```

Refactor with variables:

```
set $workspace1 "1: Terminals"
set $workspace2 "2: Chrome"
...
set $workspace10 "10: Music"

bindsym $mod+1 workspace $workspace1
bindsym $mod+2 workspace $workspace2
...
bindsym $mod+0 workspace $workspace10

bindsym $mod+Shift+1 move container to workspace $workspace1
bindsym $mod+Shift+2 move container to workspace $workspace2
...
bindsym $mod+Shift+0 move container to workspace $workspace10
```

### Assign applications to workspaces

Retrieve the window class of the application to assign by running `xprop` from a terminal and clicking on the application window. Use the second value of the `WM_CLASS` field, for example `Rhythmbox` for Rhythmbox, to assign a class to a workspace.

```
assign [class="Rhythmbox"] $workspace10
```

Note that you might have to log out and log back in for the changes to take effect.

### Display icons in workspace names

Install **Font Awesome** by downloading the lastest Zip file from https://github.com/FortAwesome/Font-Awesome/releases. Note that **Font Awesome v5** works a bit differently compared to **Font Awesome v4**. The original video uses `v4.4.0` and the latest `v4` is `v4.7.0`: https://github.com/FortAwesome/Font-Awesome/archive/v4.7.0.zip

```
cd ~/Downloads
curl -sLo Font-Awesome-4.7.0.zip https://github.com/FortAwesome/Font-Awesome/archive/v4.7.0.zip
unzip Font-Awesome-4.7.0.zip
cd Font-Awesome-4.7.0/fonts
mkdir ~/.fonts
mv fontawesome-webfont.ttf ~/.fonts/
```

Navigate to the Font Awesome Cheat Sheet: https://fontawesome.com/v4.7.0/cheatsheet/, then `Ctrl+F` your icon(s) and copy/paste them to vim (by right-clicking the icon, not the text next to it).

```
set $workspace1 "1: Terminals "
set $workspace2 "2: Chrome "
set $workspace10 "10: Music "
```

Do not worry if the icons look malformed at first in the editor. They will look just fine the next time the file is opened.

## Rice

### Change the system font

Download the Yosemite San Francisco Font from https://github.com/supermarin/YosemiteSanFranciscoFont (originally from OSX).

```
cd ~/Downloads
curl -sLo YosemiteSanFranciscoFont-master.zip https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip
unzip YosemiteSanFranciscoFont-master.zip
cd YosemiteSanFranciscoFont-master
mv *.ttf ~/.fonts/
```

Set the system font in `$I3_CONFIG_FILE` by replacing `monospace` with `System San Francisco Display`:

```
sed -i -e 's/pango:monospace/pango:System San Francisco Display/g' $I3_CONFIG_FILE
```

Also propagate the changes to GTK by installing **lxappearance** with `sudo apt install -y lxappearance` and runnnng it from the dmenu. Click the **Default font:** button and pick **SFNS Display**. Make sure to pick the **Regular** version, not the **Thin** or **Ultrathin** one. If the font cannot be found, edit the GTK configuration files located at `~/.gtkrc-2.0` and `~/.config/gtk-3.0/settings.ini`. Note that you might have to select a different font first, in order to force **lxappearance** to generate the two config files:

```
gtk-font-name=SFNS Display 8
```

Restart **lxappearance** to make sure the changes are detected correctly.

### Bar and windows colors

Copy the colors from https://github.com/bookercodes/dotfiles/blob/ubuntu/.i3/config above the `bar` block of your i3 config file:

```
set $bg-color 	         #2f343f
set $inactive-bg-color   #2f343f
set $text-color          #f3f4f5
set $inactive-text-color #676E7D
set $urgent-bg-color     #E53935

# window colors
#                       border              background         text                 indicator
client.focused          $bg-color           $bg-color          $text-color          #00ff00
client.unfocused        $inactive-bg-color  $inactive-bg-color $inactive-text-color #00ff00
client.focused_inactive $inactive-bg-color  $inactive-bg-color $inactive-text-color #00ff00
client.urgent           $urgent-bg-color    $urgent-bg-color   $text-color          #00ff00

bar {
        status_command i3status
}
```

Optionally, disable i3 edge borders with:

```
hide_edge_borders both
```

Now configure the bar colors by copying the `bar > colors` block:

```
bar {
        status_command i3status
        colors {
		background $bg-color
	    separator #757575
		#                  border             background         text
		focused_workspace  $bg-color          $bg-color          $text-color
		inactive_workspace $inactive-bg-color $inactive-bg-color $inactive-text-color
		urgent_workspace   $urgent-bg-color   $urgent-bg-color   $text-color
	}
}
```

At this point, if you use Firefox, install the **Arc Firefox** theme from https://github.com/horst3180/arc-firefox-theme so Firefox displays the same colors.

### File Explorer

Install **Thunar** with `sudo apt install -y thunar`. Test it from the dmenu. Notice the Windows 98 look-and-feel :-)

### GTK Theme and Icons

Install the **Arc GTK** theme with `sudo apt install -y arc-theme`.

Open **lxappearance** and pick your favorite Arc theme from the list on the left.

Install the **Moka** and **Paper** icon sets from https://snwh.org/moka/download.

```
sudo add-apt-repository ppa:snwh/ppa
sudo apt update -y && sudo apt install -y moka-icon-theme paper-icon-theme
```

Now pick the Moka or Paper icon theme from the **Icon Theme** tab in **lxappearance**.

### Replace dmenu with Rofi

Rofi does the same thing but is much easier to configure and customize.

Install Rofi with `sudo apt install -y rofi`.

Replace the `$mod+d` binding in `$I3_CONFIG_FILE` by copying the config from https://github.com/bookercodes/dotfiles/blob/ubuntu/.i3/config

```
bindsym $mod+d exec rofi -show run -lines 3 -eh 2 -width 100 -padding 800 -opacity "85" -bw 0 -bc "$bg-color" -bg "$bg-color" -fg "$text-color" -hlbg "$bg-color" -hlfg "#9575cd" -font "System San Francisco Display 18"
```

Use `man rofi` to understand the flags.

To enable transparency, run `sudo apt install -y compton` and set it to run on startup with:

```
cat <<EOT >> $I3_CONFIG_FILE

# Run compton on startup to handle transparency and fade effects
exec compton -f
EOT
```

### Lock Screen

Update the **i3lock** binding to include a consistent background color with:

```
bindsym $mod+shift+x exec i3lock --color "$bg-color"
```

For more customizations of the lock screen, refer to https://www.reddit.com/r/unixporn/comments/3358vu/i3lock_unixpornworthy_lock_screen/

### Status Bar & Blocks

The status bar is controlled by the `bar` block in `$I3_CONFIG_FILE`.

Blocks can be configured with `status_command`. Try running the default `i3status` status command in  a terminal to understand how it works.

To take things further, install **i3blocks** with `sudo apt install -y i3blocks` and test it locally in a terminal. Notice how the output gets refreshed automatically.

Customize **i3blocks** by copying its default configuration files:

```
cp /etc/i3blocks.conf $I3_CONFIG_FOLDER
```

Update the `status_command` in `I3_CONFIG_FILE` to use your local file with (adjust for your i3 config location)):

```
status_command i3blocks -c $HOME/.config/i3/i3blocks.conf
```

Edit `$I3_CONFIG_FOLDER/i3blocks.conf` to enable `load_average` or set `time.interval` to `1` (instead of `5` by default)

In case the volume indicator does not work as expected, fix it by setting `interval` to `1` (instead of `once` by default) and by tweaking the command with:

```
[volume]
interval=1
command=/usr/share/i3blocks/volume 5 pulse
```

Confirm the volume indicator works as expected with `pavu` or `rhythmbox`.

Finally, you can add icons by copying them from the Font Awesome Cheat Sheet:

```
[disk]
label=
```
