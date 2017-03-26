-- === Boilerplate === {{{1
-- vim:foldmethod=marker:foldcolumn=4
----- Pragmas ----- {{{2
{-# LANGUAGE GADTs #-}
----- Imports ----- {{{2
import Control.Applicative ((<$>), (<*>))
import Control.Applicative.Error (maybeRead)
import Control.Monad (when)
import Data.Char (toLower)
import Data.List (intercalate, isInfixOf)
import Data.Maybe
import Data.Monoid
import qualified SSH.Config
import System.Directory (getDirectoryContents)
import System.FilePath.Posix ((</>))
import System.IO
import System.Process (readProcess, runInteractiveCommand)
import Text.Parsec ((<?>), anyChar, many1, noneOf, parse, spaces, Parsec)
import XMonad hiding ( (|||), Tall ) -- want ||| from LayoutCombinators
import XMonad.Actions.FindEmptyWorkspace
import XMonad.Actions.GridSelect
import XMonad.Actions.GridSelect.DSL
import XMonad.Actions.Notify
import XMonad.Actions.NotifyCurrentLayout
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.Plane
import XMonad.Actions.Promote
import XMonad.Actions.UpdatePointer
import XMonad.Config.Desktop (desktopLayoutModifiers)
import XMonad.Config.Gnome
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.RestoreMinimized
import XMonad.Hooks.SetWMName
import qualified XMonad.Layout.BoringWindows as B
import XMonad.Layout.HintedGrid (Grid(..))
import XMonad.Layout.HintedTile
import XMonad.Layout.LayoutCombinators ( (|||), JumpToLayout(..))
import XMonad.Layout.LayoutHints
import XMonad.Layout.Minimize
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Spiral (spiral)
import XMonad.Layout.ThreeColumns
import XMonad.ManageHook
import XMonad.Prompt
import XMonad.Prompt.Hassh
import XMonad.Prompt.Input
import XMonad.Prompt.Window
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
    [ ("M-S-r",   gnomeRun)
    , ("M-r",     summonGnomeDo)
    , ("C-M-r",   onEmptyWorkspace summonGnomeDo)
    , ("M-i h",   ghciGridSelect)
    , ("M-i r",   irbGridSelect)
    , ("M-i p",   pryGridSelect)
    , ("M-i n",   spawnNode)
    , ("M-i y",   spawnPython)
    , ("M-i u",   ubuntuGridSelect)
    , ("M-i s",   spawnPsql)
    , ("M-i j",   spawnJq)
    , ("M-e",     goToSelected windowGSConfig)
    , ("M-S-e",   bringSelected windowGSConfig)
    , ("C-M-e",   windowPromptGoto myXPConfig)
    , ("C-M-S-e", windowPromptBring myXPConfig)

    , ("S-M-]",   soundGridSelect)

    , ("S-M-x",   spawnGvimWithArgs ".xmonad/xmonad.hs")

    ----- tools and apps ----- {{{3
    , ("M-p",     spawnX "nice top")
    , ("M-S-g",   spawnSshOptsCmd "jabberwock.vm.bytemark.co.uk" ["-t"] "vim stuff.asc")
    , ("M-g",     spawnSshOptsCmd "jabberwock.vm.bytemark.co.uk" ["-t"] "bin/passgrep")
    , ("M-s",     hasshPrompt myXPConfig sshConfig ?+ spawnSshHost)
    , ("M-S-s",   hasshPrompt myXPConfig sshConfig ?+ (\host -> spawnSshHostOpts host ["-t"] (Just "tmux attach || tmux")))
    , ("C-M-s",   hasshPrompt myXPConfig sshConfig ?+ (\portal ->
                    hasshPrompt myXPConfig sshConfig ?+ (\host ->
                      spawnSshHostOpts portal ["-t"] (Just $ "ssh " ++ SSH.Config.hostName host))))
    , ("C-M-<Return>", onEmptyWorkspace $ spawn myTerminal)

    , ("M-v",     spawn "gvim")
    , ("S-M-v",   spawnGvimWithArgs "+'set filetype=votl' +'lcd $HOME/Dropbox/Notes'")
    , ("C-M-v",   inputPrompt myXPConfig "args" ?+ spawnGvimWithArgs)
    , ("S-M-n",   spawnGvimWithArgs "+'Simplenote -l'")
    , ("M-n",     safeSpawn "gvim" ["_newnote"])

    , ("S-M-o",   spawnTail "/var/log/syslog")
    , ("C-M-o",   inputPrompt myXPConfig "file" ?+ spawnTail)

    , ("<Print>", gimpShot FullScreenshot)
    , ("S-<Print>", gimpShot WindowScreenshot)
    , ("C-<Print>", gimpShot RegionScreenshot)

    , ("M-<XF86AudioPlay>", timerStart pomodoro)
    , ("M-S-<XF86AudioPlay>", timerStart breakShort)
    , ("M-C-<XF86AudioPlay>", promptMinutes ?+ timerStart)
    , ("M-<XF86AudioStop>", timerStop)
    , ("M-S-<XF86AudioStop>", timerStop)
    , ("M-<XF86AudioNext>", spawnSshOptsCmd "jabberwock.vm.bytemark.co.uk" ["-t"] "bin/log_pomos")

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

    ----- physical screens ----- {{{3
    , ("M-<XF86Back>", viewScreen (P 0))
    , ("M-<XF86Forward>", viewScreen (P 1))
    , ("S-M-<XF86Back>", sendToScreen (P 0))
    , ("S-M-<XF86Forward>", sendToScreen (P 1))

    , ("M-<KP_Left>", viewScreen (P 0))
    , ("M-<KP_Right>", viewScreen (P 1))
    , ("S-M-<KP_Left>", sendToScreen (P 0))
    , ("S-M-<KP_Right>", sendToScreen (P 1))

    ----- window management commands ----- {{{3
    , ("M-<Space>", sendMessage NextLayout >> notifyCurrentLayout)
    , ("M-z",     withFocused minimizeWindow)
    , ("S-M-z",   sendMessage RestoreNextMinimizedWin)
    , ("M1-<F4>", kill)
    , ("M-<F11>", promote >> sendMessage (JumpToLayout "Full"))
      ----- skip boring windows when changing focus ----- {{{4
    , ("M-j",     B.focusDown)
    , ("M-k",     B.focusUp)
    , ("M-m",     B.focusMaster)
    , ("S-M-m",   promote)

    ----- session management ----- {{{3
    , ("M-<F4>",  spawn "gnome-session-save --shutdown-dialog")
    , ("C-M-q", rescreen)
    ]
    ----- helper functions ----- {{{3
    where
      summonGnomeDo =
        safeSpawn "dbus-send" ["--session", "--type=method_call", "--dest=org.gnome.Do", "/org/gnome/Do/Controller", "org.gnome.Do.Controller.Summon"]

----- Mouse bindings ----- {{{2

myMouseBindings :: [((ButtonMask, Button), Window -> X ())]
myMouseBindings =
    [
      ----- Super-scroll to transparentise window ----- {{{3
      -- Maybe useful if I ever set up conky?
      {-((myModMask, button4), fadeIn)-}
    {-, ((myModMask, button5), (flip setOpacity) 0.1)-}
    ]


-- === Layout === {{{1

----- Layout modifiers {{{2

myLayoutModifiers =
  desktopLayoutModifiers
  . B.boringAuto
  . renamed [CutWordsLeft 2] -- remove "Minimize Hinted"
  . minimize
  . layoutHintsWithPlacement (0.5, 0.5)
  . noBorders


----- Layout hook {{{2

myLayoutHook = defaultLayout
  where
    -- defaultLayout copied from source of defaultConfig
    defaultLayout = hintedTile Tall ||| hintedTile Wide ||| spiralL ||| Grid False ||| threeColMid ||| Full
    -- default tiling algorithm partitions the screen into two panes
    hintedTile   = HintedTile nmaster delta ratio TopLeft

    -- Spiral layout for more small windows
    spiralL = spiral (6/7)

    threeColMid = ThreeColMid nmaster delta ratio

    -- The default number of windows in the master pane
    nmaster = 1

    -- Default proportion of screen occupied by master pane
    ratio   = 1/2

    -- Percent of screen to increment by when resizing panes
    delta   = 3/100



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
  updatePointer (0.5, 0.5) (0.2, 0.2)
  fadeInactiveLogHook 0.85


-- === GridSelect config === {{{1

windowGSConfig :: GSConfig Window
windowGSConfig = myGSConfig

myGSConfig :: HasColorizer a => GSConfig a
myGSConfig = def
  { gs_font = "xft:Ubuntu-12"
  , gs_cellheight = 50
  , gs_cellwidth = 400
  }


-- === XPrompt config === {{{1

myXPConfig :: XPConfig
myXPConfig = def
  { font = "xft:Ubuntu-12"
  , height = 36
  }


-- === Utilities === {{{1

----- extra mouse buttons ----- {{{2

myButton4, myButton5, myButton6, myButton7, myButton8, myButton9, myButton10, myButton11 :: Button
myButton4 = button4
myButton5 = button5
myButton6 = 6
myButton7 = 7
myButton8 = 8
myButton9 = 9
myButton10 = 10
myButton11 = 11

----- workspace navigation ----- {{{2

myMove :: Direction -> X ()
myMove = planeMove planeConf Finite

myShift :: Direction -> X ()
myShift = planeShift planeConf Finite

planeConf :: Lines
planeConf = Lines 3

onEmptyWorkspace :: X a -> X a
onEmptyWorkspace = (viewEmptyWorkspace >>)

----- launching things ----- {{{2

----- spawn in xterm ----- {{{3

spawnX :: FilePath -> X ()
spawnX = spawn . ("x " ++)

safeSpawnX :: FilePath -> [String] -> X ()
safeSpawnX cmd opts = safeSpawn "x" (cmd : opts)


----- take screenshot and send to GIMP {{{3

data ScreenshotType = FullScreenshot | WindowScreenshot | RegionScreenshot

gimpShot :: ScreenshotType -> X ()
gimpShot FullScreenshot = gimpScrot False Nothing
gimpShot WindowScreenshot = gimpScrot False $ Just "--focused"
gimpShot RegionScreenshot = do
  notify "Select a region" Nothing
  -- Need to sleep before grabbing the cursor, or XMonad gets confused
  gimpScrot True (Just "--select")

gimpScrot :: Bool -> Maybe String -> X ()
gimpScrot sleep opts = spawn scrotCmd
  where
    scrotCmd = unwords $ catMaybes [sleepCmd, Just "scrot -e 'gimp $f && rm $f'", opts]
    sleepCmd = if sleep then Just "sleep 0.2;" else Nothing


----- File / directory utils ----- {{{3

dir :: FilePath -> IO [FilePath]
dir path = getDirectoryContents path >>= return . filter (not . isHidden)
  where isHidden file = head file == '.'


----- Hilarious sounds ----- {{{3

soundGridSelect :: X ()
soundGridSelect = noisyGrid_ "Playing sound" $ do
    choices $ io (dir soundDir)
    labels $ takeWhile (/= '.')
    action (\file -> safeSpawn "aplay" [soundDir </> file])
  where soundDir = "/home/sam/sounds"


----- Ruby prompts ----- {{{3

irbGridSelect :: X ()
irbGridSelect = rubyGridSelect ?+ spawnIrb

pryGridSelect :: X ()
pryGridSelect = rubyGridSelect ?+ spawnPry

spawnIrb :: String -> X ()
spawnIrb ruby = safeSpawnX "env" ["RBENV_VERSION=" ++ ruby, ".rbenv/shims/irb"]

spawnPry :: String -> X ()
spawnPry ruby = safeSpawnX "env" ["RBENV_VERSION=" ++ ruby, ".rbenv/shims/pry"]

spawnNode :: X ()
spawnNode = safeSpawnX "node" []

spawnPython :: X ()
spawnPython = safeSpawnX "ipython" []

spawnPsql :: X ()
spawnPsql = safeSpawnX "psql" ["postgres"]

spawnJq :: X ()
spawnJq = safeSpawnX "jq" ["."]

rubyGridSelect :: X (Maybe String)
rubyGridSelect = noisyGrid "Ruby" $ do
  choices $ io listRubies
  labels id
  action return
  gsConfig myGSConfig

listRubies :: IO [String]
listRubies = (:) <$> return "system" <*> dir ".rbenv/versions"


----- Ubuntu prompt ----- {{{3

ubuntuGridSelect :: X ()
ubuntuGridSelect = ubuntuImageGridSelect ?+ spawnDockerBash

spawnDockerBash :: String -> X ()
spawnDockerBash image = safeSpawnX "docker" ["run", "--rm", "-i", "-t", image, "bash"]

ubuntuImageGridSelect :: X (Maybe String)
ubuntuImageGridSelect = noisyGrid "Ubuntu image" $ do
  choices $ io (listDockerImages "ubuntu") `catchX` return []
  labels snd
  action $ return . fst
  gsConfig myGSConfig

listDockerImages :: String -> IO [(String, String)]
listDockerImages repo = map parseImageLine . drop 1 . lines <$> getCommandOutput ("docker images " <> repo)
  where
    parseImageLine :: String -> (String, String)
    parseImageLine str = case parse parser "" str of
      Right (image, tag) -> (image, tag)
      Left e -> (str, show e)
    parser :: Parsec String () (String, String)
    parser = do
      repo <- many1 (noneOf " ") <?> "image repository"
      spaces
      tag <- many1 (noneOf " ") <?> "image tag"
      spaces >> many1 anyChar
      return (repo <> ":" <> tag, tag)


getCommandOutput :: String -> IO String
getCommandOutput command = do
  (_, hOut, hErr, _) <- runInteractiveCommand command
  out <- hGetContents hOut
  err <- hGetContents hErr
  when (err /= "") $ hPutStrLn stderr err
  return out


----- ghci ----- {{{3

ghcVersionsDir :: String
ghcVersionsDir = "/opt/ghc"

ghcGridSelect :: X (Maybe String)
ghcGridSelect = noisyGrid "Haskell version" $ do
    choices $ io listHaskells
    labels id
    action return
    gsConfig myGSConfig

ghciGridSelect :: X ()
ghciGridSelect = ghcGridSelect ?+ (flip safeSpawnX [] . ghciPath)
  where ghciPath version = ghcVersionsDir ++ "/" ++ version ++ "/bin/ghci"

listHaskells :: IO [String]
listHaskells = dir ghcVersionsDir


----- timers ----- {{{3

----- timer types ----- {{{4

type TimerCommand = String

data Duration a where
    Duration :: a -> a -> a -> Duration a
    Hours :: a -> Duration a
    Minutes :: a -> Duration a
    Seconds :: a -> Duration a
  deriving (Show)

instance Read a => Read (Duration a) where
    readsPrec p = fmap dummyPair . fmap Minutes . (fmap fst . readsPrec p)
        where dummyPair x = (x, "")

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
breakLong = Minutes 30


----- spawn ssh ----- {{{3

spawnSsh :: String -> X ()
spawnSsh host = spawnSshOpts host [] Nothing

spawnSshOptsCmd :: String -> [String] -> FilePath -> X ()
spawnSshOptsCmd host opts cmd = spawnSshOpts host opts (Just cmd)

spawnSshOpts :: String -> [String] -> Maybe FilePath -> X ()
spawnSshOpts host opts maybeCmd = safeSpawnX "ssh" $
    opts ++ [host] ++ maybeToList maybeCmd

spawnSshHost :: SSH.Config.Section -> X ()
spawnSshHost host = spawnSshHostOpts host [] Nothing

spawnSshHostOpts :: SSH.Config.Section -> [String] -> Maybe FilePath -> X ()
spawnSshHostOpts = spawnSshOpts . SSH.Config.alias

----- spawn gvim ----- {{{3

spawnGvimWithArgs :: String -> X ()
spawnGvimWithArgs args = spawn ("gvim " ++ args)

----- tail a thing ----- {{{3

spawnTail :: String -> X ()
spawnTail file = safeSpawnX "less" ["-Ri", "+F", file]

----- SSH utilities ----- {{{2
sshConfig :: FilePath
sshConfig = "/home/sam/.ssh/config"

----- Prompts ----- {{{2

maybeReadM :: (Monad m, Read a) => Maybe String -> m (Maybe a)
maybeReadM = return . (>>= maybeRead)

promptMinutes :: X (Maybe (Duration Int))
promptMinutes = inputPrompt greenXPConfig "Minutes" >>= maybeReadM


-- === Put it all together === {{{1

----- XConfig ----- {{{2

myConfig = gnomeConfig
    { modMask = myModMask
    , startupHook = startupHook gnomeConfig >> myStartupHook
    , manageHook = manageHook gnomeConfig <+> composeAll myManageHook
    , layoutHook = myLayoutModifiers $ myLayoutHook
    , logHook = logHook gnomeConfig >> myLogHook
    , handleEventHook = handleEventHook gnomeConfig `mappend` myEventHook
    , workspaces = myWorkspaces
    }
    `additionalKeysP` myKeys
    `additionalMouseBindings` myMouseBindings

myTerminal = terminal myConfig

----- main function ----- {{{2

main = xmonad myConfig
