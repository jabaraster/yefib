module Handler.Entry where

import Import
import Model.Accessor
import Widgets

data EntryForm = EntryForm { dummy :: Maybe Text }

entryForm :: Html -> MForm Jabaraster Jabaraster (FormResult EntryForm, Widget)
entryForm = renderDivs $ EntryForm
  <$> aopt hiddenField "" Nothing

getEntryR :: Integer -> Handler RepHtml
getEntryR entryId = do
  maybeEntry <- runDB $ getEntryById entryId
  case maybeEntry of
    Nothing -> redirect RedirectSeeOther RootR
    Just entry -> do
      ((_, widget), enctype) <- runFormPost entryForm
      defaultLayout $ do
        setTitle "entry"
        $(widgetFile "entry")
        submitWidget
        submitWidget' "a"

postEntryR :: Integer -> Handler RepHtml
postEntryR entryId = do
  maybeEntry <- runDB $ getEntryById entryId
  case maybeEntry of
    Nothing -> redirect RedirectSeeOther RootR
    Just entry -> do
      _ <- runDB $ delete $ fst entry
      redirect RedirectSeeOther $ ThreadR $ fromKey $ entryThreadId $ snd entry
