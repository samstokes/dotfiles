import XMonad
import XMonad.Actions.Plane
import XMonad.Config.Gnome
import XMonad.Hooks.FadeInactive
import XMonad.Layout.ShowWName
import XMonad.ManageHook
import XMonad.Util.EZConfig

myModMask = mod4Mask

myLayoutModifiers = showWName

myWorkspaces = ["mail", "read", "code"] ++ map show [4..9]

myKeys :: [(String, X ())]
myKeys =
    -- launchers
    [ ("M-r",     gnomeRun)
    , ("M-S-r",   spawn "gnome-do")

    -- tools and apps
    , ("M-p",     spawn "x nice top")
    , ("M-g"    , spawn "x ssh -t jabberwock.vm.bytemark.co.uk bin/passgrep")

    -- workspace navigation
    , ("C-M-h",   myMove ToLeft)
    , ("C-M-j",   myMove ToDown)
    , ("C-M-k",   myMove ToUp)
    , ("C-M-l",   myMove ToRight)
    , ("S-C-M-h", myShift ToLeft)
    , ("S-C-M-j", myShift ToDown)
    , ("S-C-M-k", myShift ToUp)
    , ("S-C-M-l", myShift ToRight)

    -- window management commands
    , ("M1-<F4>", kill)

    -- session management
    , ("M-<F4>",  spawn "gnome-session-save --shutdown-dialog")
    ]
    where
      myMove = planeMove GConf Finite
      myShift = planeShift GConf Finite

myMouseBindings :: [((ButtonMask, Button), Window -> X ())]
myMouseBindings =
    [
    ]

myStartupHook :: X ()
myStartupHook = checkKeymap myConfig myKeys

myManageHook :: [ManageHook]
myManageHook =
    [ resource =? "Do"   --> doIgnore ]

myLogHook :: X ()
myLogHook = fadeInactiveLogHook 0.8

myConfig = gnomeConfig
    { modMask = myModMask
    , startupHook = startupHook gnomeConfig >> myStartupHook
    , manageHook = manageHook gnomeConfig <+> composeAll myManageHook
    , layoutHook = myLayoutModifiers $ layoutHook gnomeConfig
    , logHook = logHook gnomeConfig >> myLogHook
    , workspaces = myWorkspaces
    }
    `additionalKeysP` myKeys
    `additionalMouseBindings` myMouseBindings

myTerminal = terminal myConfig

main = xmonad myConfig
