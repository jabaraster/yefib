module Handler.Entry where

import Import
import Model.Accessor

data EntryForm = EntryForm { dummy :: Maybe Text }

entryForm :: Html -> MForm Jabaraster Jabaraster (FormResult EntryForm, Widget)
entryForm = renderDivs $ EntryForm
  <$> aopt hiddenField "" Nothing

getEntryR :: Integer -> Handler RepHtml
getEntryR entryId = do
  maybeEntry <- runDB $ getEntryById entryId
  case maybeEntry of
    Nothing -> redirect RedirectTemporary RootR
    Just entry -> do
      ((_, widget), enctype) <- runFormPost entryForm
      defaultLayout $ do
        setTitle "entry"
        $(widgetFile "entry")

postEntryR :: Integer -> Handler RepHtml
postEntryR entryId = do
  maybeEntry <- runDB $ getEntryById entryId
  case maybeEntry of
    Nothing -> redirect RedirectTemporary RootR
    Just entry -> do
      _ <- runDB $ delete $ fst entry
      redirect RedirectTemporary $ ThreadR $ fromKey $ entryThreadId $ snd entry
