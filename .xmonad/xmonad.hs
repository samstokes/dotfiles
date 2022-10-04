-- === Boilerplate === {{{1
-- vim:foldmethod=marker:foldcolumn=4
----- Pragmas ----- {{{2
{-# LANGUAGE GADTs #-}
----- Imports ----- {{{2
import Control.Applicative ((<$>), (<*>))
import Control.Monad (replicateM_, when)
import Data.Char (toLower)
import Data.List (intercalate, isInfixOf)
import Data.Maybe
import Data.Monoid
import System.Directory (getDirectoryContents)
import System.FilePath.Posix ((</>))
import System.IO
import System.Process (readProcess, runInteractiveCommand)
import XMonad hiding ( (|||), Tall ) -- want ||| from LayoutCombinators
import XMonad.Actions.FindEmptyWorkspace
import XMonad.Actions.GridSelect
import XMonad.Actions.GridSelect.DSL
import XMonad.Actions.Minimize (maximizeWindowAndFocus, minimizeWindow, withLastMinimized)
import XMonad.Actions.Notify
import XMonad.Actions.NotifyCurrentLayout
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.Plane
import XMonad.Actions.Promote
import XMonad.Actions.UpdatePointer
import XMonad.Config.Desktop (desktopLayoutModifiers)
import XMonad.Hooks.EwmhDesktops
import XMonad.Config.Gnome
import XMonad.Hooks.FadeInactive
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
    [ ("M-S-<Space>", gnomeRun)
    , ("M-<Space>",   summonKupfer)
    , ("C-M-<Space>", onEmptyWorkspace summonKupfer)
    , ("M-i h",   ghciGridSelect)
    , ("M-i r",   irbGridSelect)
    , ("M-i p",   pryGridSelect)
    , ("M-i n",   spawnNode)
    , ("M-i y",   spawnPython)
    , ("M-i s",   spawnPsql)
    , ("M-i j",   spawnJq)
    , ("M-e",     goToSelected windowGSConfig)
    , ("M-S-e",   bringSelected windowGSConfig)
    , ("C-M-e",   windowPromptGoto myXPConfig)
    , ("C-M-S-e", windowPromptBring myXPConfig)

    , ("S-M-]",   soundGridSelect)

    , ("S-M-x",   spawnNvimWithArgs [".xmonad/xmonad.hs"] [])

    ----- tools and apps ----- {{{3
    , ("M-p",     spawnX "nice top")
    , ("M-<Return>", spawn myTerminal)
    , ("S-M-<Return>", spawn "sensible-browser")
    , ("C-M-<Return>", onEmptyWorkspace $ spawn myTerminal)

    , ("M-v",     spawn "v")
    , ("S-M-v",   spawnNvimForNotesWithArgs [])
    , ("C-M-v",   inputPrompt myXPConfig "file" ?+ \file -> spawnNvimWithArgs [file] [])
    -- edit current clipboard contents
    , ("S-C-M-v", spawnNvimWithArgs [] ["+set buftype=nofile", "+put +", "+0,0delete", "+autocmd BufUnload <buffer> silent w !xclip -selection clipboard"])

    , ("M-x",     safeSpawn "1password" ["--toggle"])

    , ("M-n",     spawnNvimForNotesWithArgs ["+EditNewNote"])
    , ("S-M-n",   inputPrompt myXPConfig "note-title" ?+ \title -> spawnNvimForNotesWithArgs ["+EditNewNote " ++ title])

    , ("S-M-o",   spawnTail "/var/log/syslog")
    , ("C-M-o",   inputPrompt myXPConfig "file" ?+ spawnTail)

    , ("<Print>", gnomeShot FullScreenshot)
    , ("S-<Print>", gnomeShot WindowScreenshot)
    , ("C-<Print>", gnomeShot RegionScreenshot)

    ----- workspace navigation ----- {{{3
    , ("C-M-h",   myMove ToLeft)
    , ("C-M-j",   myMove ToDown)
    , ("C-M-k",   myMove ToUp)
    , ("C-M-l",   myMove ToRight)
    , ("S-C-M-h", myShift ToLeft)
    , ("S-C-M-j", myShift ToDown)
    , ("S-C-M-k", myShift ToUp)
    , ("S-C-M-l", myShift ToRight)

    , ("M-`",     viewEmptyWorkspace)
    , ("S-M-`",   tagToEmptyWorkspace)

    ----- physical screens ----- {{{3
    , ("M-<XF86Back>", viewScreen def (P 0))
    , ("M-<XF86Forward>", viewScreen def (P 1))
    , ("S-M-<XF86Back>", sendToScreen def (P 0))
    , ("S-M-<XF86Forward>", sendToScreen def (P 1))

    , ("M-<Page_Down>", viewScreen (P 1))
    , ("M-<Page_Up>", viewScreen (P 0))
    , ("S-M-<Page_Down>", sendToScreen (P 1))
    , ("S-M-<Page_Up>", sendToScreen (P 0))

    , ("M-<KP_Left>", viewScreen (P 0))
    , ("M-<KP_Right>", viewScreen (P 1))
    , ("S-M-<KP_Left>", sendToScreen (P 0))
    , ("S-M-<KP_Right>", sendToScreen (P 1))

    -- adjust scaling factor for HiDPI shenanigans
    , ("M-f", adjustScalingFactor 1)
    , ("S-M-f", adjustScalingFactor 2)

    ----- window management commands ----- {{{3
    , ("S-M-h",   replicateM_ 10 $ sendMessage Shrink)
    , ("S-M-l",   replicateM_ 10 $ sendMessage Expand)
    , ("M-t",     sendMessage NextLayout >> notifyCurrentLayout)
    , ("M-z",     withFocused minimizeWindow)
    , ("S-M-z",   withLastMinimized maximizeWindowAndFocus)
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
      summonKupfer =
        safeSpawn "kupfer" []

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
myEventHook = restoreMinimizedEventHook <+> fullscreenEventHook


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
spawnX cmd = safeSpawn "gnome-terminal" ["-e", cmd]

safeSpawnX :: FilePath -> [String] -> X ()
safeSpawnX cmd opts = safeSpawn "gnome-terminal" $ "-x" : cmd : opts


----- adjust HiDPI scaling factor {{{3

adjustScalingFactor :: Int -> X ()
adjustScalingFactor factor = safeSpawn "gsettings" opts
  where
    opts = ["set", "org.gnome.settings-daemon.plugins.xsettings", "overrides", value]
    value = "[{'Gdk/WindowScalingFactor', <" ++ show factor ++ ">}]"


----- take screenshot and send to GIMP {{{3

data ScreenshotType = FullScreenshot | WindowScreenshot | RegionScreenshot

gnomeShot :: ScreenshotType -> X ()
gnomeShot FullScreenshot = gnomeShot_ False Nothing
gnomeShot WindowScreenshot = gnomeShot_ False (Just "--window")
gnomeShot RegionScreenshot = do
    notify "Select a region" Nothing
    -- Need to sleep before grabbing the cursor, or XMonad gets confused
    gnomeShot_ True (Just "--area")

gnomeShot_ :: Bool -> Maybe String -> X ()
gnomeShot_ sleep opts = spawn shotCmd
  where
    shotCmd = unwords $ catMaybes [sleepCmd, Just "gnome-screenshot", opts]
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


----- spawn nvim ----- {{{3

spawnNvimWithArgs :: [String] -> [String] -> X ()
spawnNvimWithArgs files nvimArgs = safeSpawn "v" $ nvimArgs ++ files

spawnNvimForNotesWithArgs :: [String] -> X ()
spawnNvimForNotesWithArgs extraNvimArgs = spawnNvimWithArgs [] $ nvimArgs ++ extraNvimArgs
  where nvimArgs = ["+lcd $HOME/Notes", "+unlet g:ctrlp_user_command", "+let g:ctrlp_working_path_mode = 'a'"]

----- tail a thing ----- {{{3

spawnTail :: String -> X ()
spawnTail file = safeSpawnX "less" ["-Ri", "+F", file]

-- === Put it all together === {{{1

----- XConfig ----- {{{2

myConfig = ewmh gnomeConfig
    { modMask = myModMask
    , startupHook = startupHook gnomeConfig >> myStartupHook
    , manageHook = manageHook gnomeConfig <+> composeAll myManageHook
    , layoutHook = myLayoutModifiers $ myLayoutHook
    , logHook = logHook gnomeConfig >> myLogHook
    , handleEventHook = handleEventHook gnomeConfig <+> myEventHook
    , workspaces = myWorkspaces
    }
    `additionalKeysP` myKeys
    `additionalMouseBindings` myMouseBindings

myTerminal = terminal myConfig

----- main function ----- {{{2

main = xmonad myConfig
