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
import XMonad (X, catchX, spawn, whenJust)
import XMonad.Actions.GridSelect


withLabels :: (a -> b) -> [a] -> [(b, a)]
withLabels label items = (map label items) `zip` items

notify :: String -> X ()
notify msg = spawn $ "xmessage " ++ msg

data GridDoOpts item = GridDoOpts {
                                  gridDoChoices :: X [item]
                                , gridDoConfig :: GSConfig item
                                , gridDoLabels :: item -> String
                                , gridDoAction :: item -> X ()
                                }
defaultGridDoOpts :: GridDoOpts item
defaultGridDoOpts = GridDoOpts {
    gridDoChoices = error "must specify choices"
  , gridDoConfig = error "must specify gsConfig"
  , gridDoLabels = error "must specify labels"
  , gridDoAction = error "must specify action"
  }

gridDo :: GridDoOpts item -> X ()
gridDo opts = do
    choices <- gridDoChoices opts
    case choices of
      [] -> notify "Couldn't find any choices!"
      [choice] -> gridDoAction opts choice
      _ -> do
          choice <- gridselect (gridDoConfig opts) $ withLabels (gridDoLabels opts) choices
          whenJust choice (gridDoAction opts)


newtype GridDoT m item a = GridDoT {
    runGridDoT :: StateT (GridDoOpts item) m a
  } deriving (Monad, MonadState (GridDoOpts item))


grid :: GridDoT X item () -> X ()
grid gdt = do
    (_, opts) <- runStateT (runGridDoT gdt) defaultGridDoOpts
    gridDo opts
  `catchX` notify "grid went wrong - missing an option? check .xsession-errors"


choices :: Monad m => X [item] -> GridDoT m item ()
choices getChoices = modify (\opts -> opts { gridDoChoices = getChoices })

gsConfig :: Monad m => GSConfig item -> GridDoT m item ()
gsConfig config = modify (\opts -> opts { gridDoConfig = config })

labels :: Monad m => (item -> String) -> GridDoT m item ()
labels labeller = modify (\opts -> opts { gridDoLabels = labeller })

action :: Monad m => (item -> X ()) -> GridDoT m item ()
action f = modify (\opts -> opts { gridDoAction = f })
