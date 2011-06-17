module XMonad.Actions.Notify
  ( notify
  )
where

import Data.Maybe
import XMonad (X)
import XMonad.Util.Run

notify :: String -> Maybe String -> X ()
notify title maybeBody = safeSpawn "notify-send" $
    [title] ++ maybeToList maybeBody
