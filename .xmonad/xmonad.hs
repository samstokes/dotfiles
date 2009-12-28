import XMonad
import XMonad.Config.Gnome
import XMonad.ManageHook

main = xmonad $ gnomeConfig
    { modMask = mod4Mask
    , manageHook = manageHook gnomeConfig <+> composeAll myManageHook
    }

myManageHook :: [ManageHook]
myManageHook =
    [ resource =? "Do"   --> doIgnore ]
