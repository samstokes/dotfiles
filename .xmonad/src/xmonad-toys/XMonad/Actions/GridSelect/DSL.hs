{-# LANGUAGE PackageImports #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module XMonad.Actions.GridSelect.DSL
  ( grid
  , grid_
  , choices
  , gsConfig
  , labels
  , action
  )
where

import "mtl" Control.Monad.State
import XMonad (X, catchX, spawn, whenJust)
import XMonad.Actions.GridSelect
import XMonad.Actions.Notify


withLabels :: (a -> b) -> [a] -> [(b, a)]
withLabels label items = (map label items) `zip` items

gridNotify :: String -> X ()
gridNotify = notify "grid" . Just

data GridDoOpts item result = GridDoOpts {
                                  gridDoChoices :: X [item]
                                , gridDoConfig :: GSConfig item
                                , gridDoLabels :: item -> String
                                , gridDoAction :: item -> X result
                                }
defaultGridDoOpts :: GridDoOpts item result
defaultGridDoOpts = GridDoOpts {
    gridDoChoices = error "must specify choices"
  , gridDoConfig = error "must specify gsConfig"
  , gridDoLabels = error "must specify labels"
  , gridDoAction = error "must specify action"
  }

gridDo :: GridDoOpts item result -> X (Maybe result)
gridDo opts = do
    choices <- gridDoChoices opts
    case choices of
      [] -> gridNotify "Couldn't find any choices!" >> return Nothing
      [choice] -> doAction choice
      _ -> do
          choice <- gridselect (gridDoConfig opts) $ withLabels (gridDoLabels opts) choices
          case choice of
            Just choice' -> doAction choice'
            Nothing -> return Nothing
  where doAction choice = gridDoAction opts choice >>= return . Just


newtype GridDoT m item result a = GridDoT {
    runGridDoT :: StateT (GridDoOpts item result) m a
  } deriving (Monad, MonadState (GridDoOpts item result))


grid :: GridDoT X item result () -> X (Maybe result)
grid gdt = do
    (_, opts) <- runStateT (runGridDoT gdt) defaultGridDoOpts
    gridDo opts
  `catchX` (gridNotify "grid went wrong - missing an option? check .xsession-errors" >> return Nothing)

grid_ :: GridDoT X item result () -> X ()
grid_ gdt = grid gdt >> return ()


choices :: Monad m => X [item] -> GridDoT m item result ()
choices getChoices = modify (\opts -> opts { gridDoChoices = getChoices })

gsConfig :: Monad m => GSConfig item -> GridDoT m item result ()
gsConfig config = modify (\opts -> opts { gridDoConfig = config })

labels :: Monad m => (item -> String) -> GridDoT m item result ()
labels labeller = modify (\opts -> opts { gridDoLabels = labeller })

action :: Monad m => (item -> X result) -> GridDoT m item result ()
action f = modify (\opts -> opts { gridDoAction = f })
