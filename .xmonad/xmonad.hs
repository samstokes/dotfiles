import XMonad
import XMonad.Config.Gnome
import XMonad.ManageHook

myModMask = mod4Mask

main = xmonad $ gnomeConfig
    { modMask = myModMask
    , manageHook = manageHook gnomeConfig <+> composeAll myManageHook
    }

myManageHook :: [ManageHook]
myManageHook =
    [ resource =? "Do"   --> doIgnore ]
