import Data.Monoid
import XMonad
import XMonad.Actions.Plane
import XMonad.Actions.UpdatePointer
import XMonad.Config.Gnome
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.RestoreMinimized
import XMonad.Layout.BoringWindows
import XMonad.Layout.LayoutHints
import XMonad.Layout.Minimize
import XMonad.Layout.NoBorders
import XMonad.Layout.ShowWName
import XMonad.ManageHook
import XMonad.Util.EZConfig

myModMask = mod4Mask

myLayoutModifiers =
    boringAuto
  . minimize
  . showWName
  . layoutHintsWithPlacement (0.5, 0.5)
  . noBorders

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
    , ("M-z",     withFocused (\win -> sendMessage (MinimizeWin win)))
    , ("S-M-z",   sendMessage RestoreNextMinimizedWin)
    , ("M1-<F4>", kill)

      -- skip boring windows when changing focus
    , ("M-j",     focusDown)
    , ("M-k",     focusUp)
    , ("M-m",     focusMaster)

    -- session management
    , ("M-<F4>",  spawn "gnome-session-save --shutdown-dialog")
    ]
    where
      myMove = planeMove GConf Finite
      myShift = planeShift GConf Finite

myMouseBindings :: [((ButtonMask, Button), Window -> X ())]
myMouseBindings =
    [
      -- Super-scroll to transparentise window
      -- Maybe useful if I ever set up conky?
      {-((myModMask, button4), fadeIn)-}
    {-, ((myModMask, button5), (flip setOpacity) 0.1)-}
    ]

myEventHook :: Event -> X All
myEventHook = restoreMinimizedEventHook

myStartupHook :: X ()
myStartupHook = checkKeymap myConfig myKeys

myManageHook :: [ManageHook]
myManageHook =
    [ resource =? "Do"   --> doIgnore ]

myLogHook :: X ()
myLogHook = do
  updatePointer $ TowardsCentre 0.2 0.2
  fadeInactiveLogHook 0.8

myConfig = gnomeConfig
    { modMask = myModMask
    , startupHook = startupHook gnomeConfig >> myStartupHook
    , manageHook = manageHook gnomeConfig <+> composeAll myManageHook
    , layoutHook = myLayoutModifiers $ layoutHook gnomeConfig
    , logHook = logHook gnomeConfig >> myLogHook
    , handleEventHook = handleEventHook gnomeConfig `mappend` myEventHook
    , workspaces = myWorkspaces
    }
    `additionalKeysP` myKeys
    `additionalMouseBindings` myMouseBindings

myTerminal = terminal myConfig

main = xmonad myConfig
