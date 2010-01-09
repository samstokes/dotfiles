-- vim:foldmethod=marker:foldcolumn=4
-- === Imports === {{{1
import Data.List (intercalate)
import Data.Maybe
import Data.Monoid
import qualified SSH.Config
import Text.ParserCombinators.Parsec (parse, ParseError)
import XMonad
import XMonad.Actions.GridSelect
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
import XMonad.Util.Run


-- === Keyboard and mouse === {{{1

myModMask = mod4Mask

----- Keyboard bindings ----- {{{2
-- These are EZConfig emacs-style bindings
-- (see http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-EZConfig.html)
-- The startupHook (below) checks for syntax errors and duplicate bindings.

myKeys :: [(String, X ())]
myKeys =
    ----- launchers ----- {{{3
    [ ("M-r",     gnomeRun)
    , ("M-S-r",   spawn "gnome-do")
    , ("M-e",     goToSelected windowGSConfig)
    , ("M-S-e",   bringSelected windowGSConfig)

    ----- tools and apps ----- {{{3
    , ("M-p",     spawnX "nice top")
    , ("M-g",     spawnSshOptsCmd "jabberwock.vm.bytemark.co.uk" ["-t"] "bin/passgrep")
    , ("M-s",     sshGridSelect)

    ----- workspace navigation ----- {{{3
    , ("C-M-h",   myMove ToLeft)
    , ("C-M-j",   myMove ToDown)
    , ("C-M-k",   myMove ToUp)
    , ("C-M-l",   myMove ToRight)
    , ("S-C-M-h", myShift ToLeft)
    , ("S-C-M-j", myShift ToDown)
    , ("S-C-M-k", myShift ToUp)
    , ("S-C-M-l", myShift ToRight)

    ----- window management commands ----- {{{3
    , ("M-z",     withFocused (\win -> sendMessage (MinimizeWin win)))
    , ("S-M-z",   sendMessage RestoreNextMinimizedWin)
    , ("M1-<F4>", kill)
      ----- skip boring windows when changing focus ----- {{{4
    , ("M-j",     focusDown)
    , ("M-k",     focusUp)
    , ("M-m",     focusMaster)

    ----- session management ----- {{{3
    , ("M-<F4>",  spawn "gnome-session-save --shutdown-dialog")
    ]
    ----- helper functions ----- {{{3
    where
      myMove = planeMove GConf Finite
      myShift = planeShift GConf Finite

----- Mouse bindings ----- {{{2

myMouseBindings :: [((ButtonMask, Button), Window -> X ())]
myMouseBindings =
    [
      ----- Super-scroll to transparentise window ----- {{{3
      -- Maybe useful if I ever set up conky?
      {-((myModMask, button4), fadeIn)-}
    {-, ((myModMask, button5), (flip setOpacity) 0.1)-}
    ]


-- === Layout modifiers === {{{1

myLayoutModifiers =
    boringAuto
  . minimize
  . showWName
  . layoutHintsWithPlacement (0.5, 0.5)
  . noBorders


-- === Workspace setup === {{{1

myWorkspaces = ["mail", "read", "code"] ++ map show [4..9]


-- === Event hook === {{{1

myEventHook :: Event -> X All
myEventHook = restoreMinimizedEventHook


-- === Startup hook === {{{1

myStartupHook :: X ()
myStartupHook = checkKeymap myConfig myKeys


-- === Manage hook === {{{1

myManageHook :: [ManageHook]
myManageHook = hookAll `concatMap` [ (doFloat,  floatables)
                                   , (doIgnore, ignorables)
                                   ]
  where
    ----- windows to ignore completely (don't manage) {{{2
    ignorables = [ resource =? "Do"
                 ]
    ----- windows to float {{{2
    floatables = [ className =? "Gcalctool"
                 ]
    ----- helper functions ----- {{{2
    hookAll (hook, queries) = [query --> hook | query <- queries]


-- === Log hook === {{{1

myLogHook :: X ()
myLogHook = do
  updatePointer $ TowardsCentre 0.2 0.2
  fadeInactiveLogHook 0.8


-- === GridSelect config === {{{1

windowGSConfig :: GSConfig Window
windowGSConfig = defaultGSConfig


-- === Utilities === {{{1

----- launching things ----- {{{2

spawnX :: FilePath -> X ()
spawnX = spawn . ("x " ++)

safeSpawnX :: FilePath -> [String] -> X ()
safeSpawnX cmd opts = safeSpawn "x" (cmd : opts)

notify :: String -> Maybe String -> X ()
notify title maybeBody = safeSpawn "notify-send" $
    [title] ++ maybeToList maybeBody

spawnSsh :: String -> X ()
spawnSsh host = spawnSshOpts host [] Nothing

spawnSshOptsCmd :: String -> [String] -> FilePath -> X ()
spawnSshOptsCmd host opts cmd = spawnSshOpts host opts (Just cmd)

spawnSshOpts :: String -> [String] -> Maybe FilePath -> X ()
spawnSshOpts host opts maybeCmd = safeSpawnX "ssh" $
    opts ++ [host] ++ maybeToList maybeCmd

----- SSH utilities ----- {{{2
sshGridSelect :: X ()
sshGridSelect = io readSshHosts >>= sshGridSelect'
  where
    sshGridSelect' [] = notify "SSH" (Just "Couldn't find any hosts defined")
    sshGridSelect' hostSections = do
      let hosts = map SSH.Config.name hostSections
      host <- gridselect defaultGSConfig (zip hosts hosts)
      whenJust host spawnSsh

sshConfig :: FilePath
sshConfig = "/home/sam/.ssh/config"

readSshHosts :: IO [SSH.Config.Section]
readSshHosts = do
    configFile <- readFile sshConfig
    case parse SSH.Config.parser sshConfig configFile of
      Left parseError -> fail $ show parseError
      Right config -> return $ SSH.Config.sections config
  `catch` handleError
  where handleError e = print e >> return []


-- === Put it all together === {{{1

----- XConfig ----- {{{2

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

----- main function ----- {{{2

main = xmonad myConfig
