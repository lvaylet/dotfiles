import XMonad
import XMonad.Actions.UpdatePointer -- allow pointer-follow-focus
import XMonad.Config.Azerty
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

myConfig = def -- def, defaultConfig, desktopConfig...

myKeys = \c -> azertyKeys c <+> keys myConfig c

myStartupHook = do
    spawnOnce "nitrogen --restore &" -- restore wallpaper
    spawnOnce "compton &" -- enable transparency effects

-- first fixup for docks
myLayoutHook = avoidStruts $ layoutHook myConfig

-- second fixup for docks
myManageHook = manageDocks <+> manageHook myConfig

main = do
    -- run xmobar on monitor 0
    xmproc <- spawnPipe "/usr/bin/xmobar -x 0 /home/laurent/.config/xmobar/xmobarrc"
    -- run xmonad
    xmonad $ docks myConfig
        { terminal    = "alacritty"
        , modMask     = mod1Mask
        , borderWidth = 3
        , keys        = myKeys
        , layoutHook  = myLayoutHook
        -- add xmobar to xmonad
        , logHook = dynamicLogWithPP $
            xmobarPP {
                ppOutput = hPutStrLn xmproc
            }
        , manageHook  = myManageHook
        , startupHook = myStartupHook
        }
