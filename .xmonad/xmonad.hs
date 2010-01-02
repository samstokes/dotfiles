import XMonad
import XMonad.Actions.Plane
import XMonad.Config.Gnome
import XMonad.Layout.ShowWName
import XMonad.ManageHook
import XMonad.Util.EZConfig

myModMask = mod4Mask

myLayoutModifiers = showWName

myWorkspaces = ["mail", "read", "code"] ++ map show [4..9]

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
    , ("M1-<F4>", kill)
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
    , layoutHook = myLayoutModifiers $ layoutHook gnomeConfig
    , workspaces = myWorkspaces
    }
    `additionalKeysP` myKeys

myTerminal = terminal myConfig

main = xmonad myConfig
