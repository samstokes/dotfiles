module XMonad.Prompt.Hassh
  ( hasshPrompt
  ) where

import Data.List (sortBy)
import Data.Maybe (fromJust)
import Data.Ord (comparing)
import SSH.Config
import Text.ParserCombinators.Parsec (parse)
import XMonad
import XMonad.Prompt
import XMonad.Prompt.Input ((?+))


data HasshPrompt = HasshPrompt { sshConfigPath :: FilePath }


instance XPrompt HasshPrompt where
  showXPrompt _ = "ssh host: "
  nextCompletion _ = getNextCompletion


hasshPrompt :: XPConfig -> FilePath -> X (Maybe Section)
hasshPrompt xpConfig sshConfig = do
    hosts <- io $ readSshHosts sshConfig
    let sortedHosts = sortBy (comparing label) hosts
        hostsByAlias = zip (map alias sortedHosts) sortedHosts
        hostsByLabel = zip (map label sortedHosts) sortedHosts
        completeHostLabels = mkComplFunFromLabelledList' hostsByLabel
        hostByLabel = flip lookup hostsByLabel
        hostByAlias = flip lookup hostsByAlias
        lookupHost = hostByAlias `orElse` hostByLabel
    mkXPromptWithReturn (HasshPrompt sshConfig) xpConfig completeHostLabels (return . fromJust . lookupHost)


mkComplFunFromLabelledList' :: [(String, a)] -> String -> IO [String]
mkComplFunFromLabelledList' l [] = return $ map fst l
mkComplFunFromLabelledList' l s =
  return $ filter (\x -> take (length s) x == s) $ map fst l


orElse :: (a -> Maybe b) -> (a -> Maybe b) -> a -> Maybe b
orElse f g a = case f a of
                Just r -> Just r
                Nothing -> g a


readSshHosts :: FilePath -> IO [SSH.Config.Section]
readSshHosts sshConfig = do
    configFile <- readFile sshConfig
    case parse SSH.Config.parser sshConfig configFile of
      Left parseError -> fail $ show parseError
      Right config -> return $ SSH.Config.sections config
  `catch` handleError
  where handleError e = print e >> return []
