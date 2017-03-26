module XMonad.Actions.NotifyCurrentLayout
  ( notifyCurrentLayout
  )
where

import Control.Monad.State (gets)
import XMonad.Core (X, description, windowset)
import XMonad.Actions.Notify
import qualified XMonad.StackSet as W


currentWorkspace = fmap (W.workspace . W.current) $ gets windowset

currentLayoutDesc :: X String
currentLayoutDesc = fmap (description . W.layout) $ currentWorkspace

notifyCurrentLayout :: X ()
notifyCurrentLayout = do
  currentWorkspace <- fmap (W.workspace . W.current) $ gets windowset
  let layoutDesc = description $ W.layout currentWorkspace
  notify layoutDesc Nothing
