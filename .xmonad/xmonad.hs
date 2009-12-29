import XMonad
import XMonad.Actions.Plane
import XMonad.Config.Gnome
import XMonad.ManageHook
import XMonad.Util.EZConfig

myModMask = mod4Mask

myKeys :: [(String, X ())]
myKeys =
    [ ("M-r"    , gnomeRun)
    , ("M-S-r"  , spawn "gnome-do")
    , ("M-p"    , spawn "x nice top")
    , ("M-t"    , spawn myTerminal)
    , ("C-M-h"  , myMove ToLeft)
    , ("C-M-j"  , myMove ToDown)
    , ("C-M-k"  , myMove ToUp)
    , ("C-M-l"  , myMove ToRight)
    , ("S-C-M-h", myShift ToLeft)
    , ("S-C-M-j", myShift ToDown)
    , ("S-C-M-k", myShift ToUp)
    , ("S-C-M-l", myShift ToRight)
    ]
    where
      myMove = planeMove GConf Finite
      myShift = planeShift GConf Finite

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
