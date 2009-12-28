import XMonad
import XMonad.Config.Gnome
import XMonad.ManageHook
import XMonad.Util.EZConfig

myModMask = mod4Mask

myKeys :: [(String, X ())]
myKeys =
    [ ("M-S-p", spawn "gnome-do")
    , ("M-t"  , spawn myTerminal)
    ]

myStartupHook :: X ()
myStartupHook = checkKeymap myConfig myKeys

myManageHook :: [ManageHook]
myManageHook =
    [ resource =? "Do"   --> doIgnore ]

myConfig = gnomeConfig
    { modMask = myModMask
    , startupHook = startupHook gnomeConfig >> myStartupHook
    , manageHook = manageHook gnomeConfig <+> composeAll myManageHook
    }
    `additionalKeysP` myKeys

myTerminal = terminal myConfig

main = xmonad myConfig
