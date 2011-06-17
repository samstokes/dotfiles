{-# LANGUAGE PackageImports #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module XMonad.Actions.GridSelect.DSL
  ( grid
  , choices
  , gsConfig
  , labels
  , action
  )
where

import "mtl" Control.Monad.State
import XMonad (X, spawn, whenJust)
import XMonad.Actions.GridSelect


withLabels :: (a -> b) -> [a] -> [(b, a)]
withLabels label items = (map label items) `zip` items


data GridDoOpts = GridDoOpts {
                      gridDoChoices :: X [String]
                    , gridDoConfig :: GSConfig String
                    , gridDoLabels :: String -> String
                    , gridDoAction :: String -> X ()
                    }
defaultGridDoOpts :: GridDoOpts
defaultGridDoOpts = GridDoOpts (return (map show [0..5])) defaultGSConfig id notify

notify :: String -> X ()
notify msg = spawn $ "xmessage " ++ msg

gridDo :: GridDoOpts -> X ()
gridDo opts = do
    choices <- gridDoChoices opts
    case choices of
      [] -> notify "Couldn't find any choices!"
      [choice] -> gridDoAction opts choice
      _ -> do
          choice <- gridselect (gridDoConfig opts) $ withLabels (gridDoLabels opts) choices
          whenJust choice (gridDoAction opts)


newtype GridDoT m a = GridDoT {
    runGridDoT :: StateT GridDoOpts m a
  } deriving (Monad, MonadState GridDoOpts)

grid :: GridDoT X () -> X ()
grid gdt = do
    (_, opts) <- runStateT (runGridDoT gdt) defaultGridDoOpts
    gridDo opts



choices :: Monad m => X [String] -> GridDoT m ()
choices getChoices = modify (\opts -> opts { gridDoChoices = getChoices })

gsConfig :: Monad m => GSConfig String -> GridDoT m ()
gsConfig config = modify (\opts -> opts { gridDoConfig = config })

labels :: Monad m => (String -> String) -> GridDoT m ()
labels labeller = modify (\opts -> opts { gridDoLabels = labeller })

action :: Monad m => (String -> X ()) -> GridDoT m ()
action f = modify (\opts -> opts { gridDoAction = f })
