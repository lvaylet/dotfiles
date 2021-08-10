#
# ~/.bashrc
#

### EXPORT

export TERM="xterm-256color"             # getting proper colors
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries

# Default editors. See https://unix.stackexchange.com/questions/4859/visual-vs-editor-what-s-the-difference for the difference between EDITOR and VISUAL.
export EDITOR="vi -e"
export VISUAL="vim"

### MANPAGER

# Uncomment only one of those!
export MANPAGER="sh -c 'col -bx | bat -l man -p'"  # bat
#export MANPAGER='/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'  # vim
#export MANPAGER="nvim -c 'set ft=man' -"  # nvim

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### PROMPT

# Comment out if using starship
#PS1='[\u@\h \W]\$ '

### PATH
[ -d "$HOME/.bin" ] && PATH="$HOME/.bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/Applications" ] && PATH="$HOME/Applications:$PATH"

### CHANGE TITLE OF TERMINALS

case ${TERM} in
  xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|alacritty|st|konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
  screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac

### SHELL OPTIONS

shopt -s autocd          # change to named directory
shopt -s cdspell         # autocorrects cd misspellings
shopt -s cmdhist         # save multi-line commands in history as single line
shopt -s dotglob         # include filename beginning with a '.' in the results of filename expansion
shopt -s histappend      # do not overwrite history
shopt -s expand_aliases  # expand aliases
shopt -s checkwinsize    # checks term size when bash regains control

# ignore upper and lowercase on TAB completion
bind "set completion-ignore-case on"

### HELPER FUNCTIONS

# Archive extraction
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Navigation
up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}


### ALIASES

# Root privileges
alias doas="doas --"

# Download and run install script from my GitHub Gists
alias install='curl -Lo install_my_linux.sh https://git.io/JRsiW && chmod u+x install_my_linux.sh && ./install_my_linux.sh'

# vim
alias vim="nvim"

# bat
alias cat='bat'

# broot
alias br='broot -dhp'
alias bs='broot --sizes'

# pacman and yay
alias pacsyu='sudo pacman -Syyu'                 # update only standard pkgs
alias yaysua='yay -Sua --noconfirm'              # update only AUR pkgs (yay)
alias yaysyu='yay -Syu --noconfirm'              # update standard pkgs and AUR pkgs (yay)
alias parsua='paru -Sua --noconfirm'             # update only AUR pkgs (paru)
alias parsyu='paru -Syu --noconfirm'             # update standard pkgs and AUR pkgs (paru)
alias unlock='sudo rm /var/lib/pacman/db.lck'    # remove pacman lock
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'  # remove orphaned packages

# Changing "ls" to "exa"
alias ls='exa -al --color=always --group-directories-first'  # my preferred listing
alias la='exa -a --color=always --group-directories-first'   # all files and dirs
alias ll='exa -l --color=always --group-directories-first'   # long format
alias lt='exa -aT --color=always --group-directories-first'  # tree listing
alias l.='exa -a | egrep "^\."'

# Get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# Get top processes eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

# Get top processes eating cpu
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

# Get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# GPG encryption
# Verify the signature of an ISO
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# Receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

# Switch between shells
# I do not recommend switching default SHELL from bash.
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

# Bare git repo alias for dotfiles
alias dotfiles="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

### BROOT

source ~/.config/broot/launcher/bash/br

### STARSHIP

eval "$(starship init bash)"
