-- === Boilerplate === {{{1
-- vim:foldmethod=marker:foldcolumn=4
----- Pragmas ----- {{{2
{-# LANGUAGE GADTs #-}
----- Imports ----- {{{2
import Data.Char (toLower)
import Data.List (intercalate, isInfixOf)
import Data.Maybe
import Data.Monoid
import qualified SSH.Config
import Text.ParserCombinators.Parsec (parse, ParseError)
import XMonad
import XMonad.Actions.FindEmptyWorkspace
import XMonad.Actions.GridSelect
import XMonad.Actions.Plane
import XMonad.Actions.UpdatePointer
import XMonad.Config.Gnome
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.RestoreMinimized
import XMonad.Hooks.SetWMName
import qualified XMonad.Layout.BoringWindows as B
import XMonad.Layout.LayoutHints
import XMonad.Layout.Minimize
import XMonad.Layout.NoBorders
import XMonad.ManageHook
import qualified XMonad.StackSet as W
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
    , ("M-S-g",   spawnSshOptsCmd "jabberwock.vm.bytemark.co.uk" ["-t"] "vim stuff.asc")
    , ("M-g",     spawnSshOptsCmd "jabberwock.vm.bytemark.co.uk" ["-t"] "bin/passgrep")
    , ("M-s",     sshGridSelect)
    , ("C-M-<Return>", viewEmptyWorkspace >> spawn myTerminal)

    , ("M-v",     spawn "gvim")

    , ("<Print>", spawn "gnome-screenshot")
    , ("S-<Print>", spawn "gnome-screenshot -w")

    , ("M-<XF86AudioPlay>", timerStart pomodoro)
    , ("M-S-<XF86AudioPlay>", timerStart breakShort)
    , ("M-C-<XF86AudioPlay>", timerStart breakLong)
    , ("M-<XF86AudioStop>", timerStop)
    , ("M-S-<XF86AudioStop>", timerStop)

    ----- workspace navigation ----- {{{3
    , ("C-M-h",   myMove ToLeft)
    , ("C-M-j",   myMove ToDown)
    , ("C-M-k",   myMove ToUp)
    , ("C-M-l",   myMove ToRight)
    , ("S-C-M-h", myShift ToLeft)
    , ("S-C-M-j", myShift ToDown)
    , ("S-C-M-k", myShift ToUp)
    , ("S-C-M-l", myShift ToRight)

    , ("M-<Backspace>",     viewEmptyWorkspace)
    , ("S-M-<Backspace>",   tagToEmptyWorkspace)

    ----- window management commands ----- {{{3
    , ("M-z",     withFocused (\win -> sendMessage (MinimizeWin win)))
    , ("S-M-z",   sendMessage RestoreNextMinimizedWin)
    , ("M1-<F4>", kill)
      ----- skip boring windows when changing focus ----- {{{4
    , ("M-j",     B.focusDown)
    , ("M-k",     B.focusUp)
    , ("M-m",     B.focusMaster)

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
    B.boringAuto
  . minimize
  . layoutHintsWithPlacement (0.5, 0.5)
  . noBorders


-- === Workspace setup === {{{1

myWorkspaces = ["mail", "read", "code"] ++ map show [4..9]


-- === Event hook === {{{1

myEventHook :: Event -> X All
myEventHook = restoreMinimizedEventHook


-- === Startup hook === {{{1

myStartupHook :: X ()
myStartupHook = do
  setWMName "LG3D" -- lie about my name to fool Java programs into not breaking
  checkKeymap myConfig myKeys


-- === Manage hook === {{{1

myManageHook :: [ManageHook]
myManageHook = hookAll `concatMap` [ (doFloat,  floatables)
                                   , (doIgnore, ignorables)
                                   , (doF W.shiftMaster, masters)
                                   ]
  where
    ----- windows to ignore completely (don't manage) {{{2
    ignorables = [ resource =? "Do"
                 ]
    ----- windows to float {{{2
    floatables = [ className =? "Gcalctool"
                 ]
    ----- windows that should be made master when they appear {{{2
    masters = [
                -- make git commit message editor master - this will only
                -- work if gvim is invoked via a symlink called 'git-msg-vim'
                fmap ("Git-msg-vim" `isInfixOf`) className
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

----- spawn in xterm ----- {{{3

spawnX :: FilePath -> X ()
spawnX = spawn . ("x " ++)

safeSpawnX :: FilePath -> [String] -> X ()
safeSpawnX cmd opts = safeSpawn "x" (cmd : opts)


----- popup notifications ----- {{{3

notify :: String -> Maybe String -> X ()
notify title maybeBody = safeSpawn "notify-send" $
    [title] ++ maybeToList maybeBody


----- timers ----- {{{3

----- timer types ----- {{{4

type TimerCommand = String

data Duration a where
    Duration :: a -> a -> a -> Duration a
    Hours :: a -> Duration a
    Minutes :: a -> Duration a
    Seconds :: a -> Duration a
  deriving (Show)

toHMS :: Show a => Duration a -> [String]
toHMS (Duration h m s) = map show [h, m, s]
toHMS (Hours h) = [show h, "0", "0"]
toHMS (Minutes m) = ["0", show m, "0"]
toHMS (Seconds s) = ["0", "0", show s]

newtype NiceDuration a = NiceDuration { unNice :: Duration a }
instance Show a => Show (NiceDuration a) where
  show = unwords . reverse . map (map toLower) . words . show . unNice

----- timer helper functions ----- {{{4

timerStart :: Show a => Duration a -> X ()
timerStart duration = do
  notify "Starting timer" (Just $ show $ NiceDuration duration)
  timer "start" $ toHMS duration

timerStop :: X ()
timerStop = notify "Stopping timer" Nothing >> timer "stop" []

timer :: TimerCommand -> [String] -> X ()
timer command options = safeSpawn "timer-applet-cli.py" $ command : options


----- standard time periods ----- {{{4

pomodoro, breakShort, breakLong :: Duration Int
pomodoro = Minutes 25
breakShort = Minutes 5
breakLong = Minutes 25


----- spawn ssh ----- {{{3

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
