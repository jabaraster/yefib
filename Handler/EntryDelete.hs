module Handler.EntryDelete where

import Import
import Model.Accessor

postEntryDeleteR :: Integer -> Handler RepHtml
postEntryDeleteR entryId = do
  maybeEntry <- runDB $ getEntryById entryId
  case maybeEntry of
    Nothing -> do
      redirect RedirectSeeOther RootR -- ThreadのPK値がないのでルートまで戻るしかない
    Just entry -> do
      runDB $ delete $ fst entry
      redirect RedirectSeeOther (ThreadR $ fromKey $ entryThreadId $ snd entry)

