module Handler.Thread where

import Import
import Data.Time.Clock (getCurrentTime)
import Model.Accessor
import Widgets

data EntryForm = EntryForm {
  content :: Textarea
}

entryForm :: Html -> MForm Jabaraster Jabaraster (FormResult EntryForm, Widget)
entryForm = renderDivs $ EntryForm
  <$> areq textareaField "投稿" Nothing

getThreadR :: Integer -> Handler RepHtml
getThreadR threadId = do

  maybeThread <- runDB $ getThreadById threadId

  case maybeThread of
    Nothing -> redirect RedirectSeeOther RootR

    Just thread -> do
      ((_, widget), enctype) <- runFormPost entryForm
      entries <- runDB $ getEntriesByThreadId $ fromKey $ fst thread
      defaultLayout $ do
        setTitle "thread"
        $(widgetFile "thread")
        submitWidget

postThreadR :: Integer -> Handler RepHtml
postThreadR threadId = do

  maybeThread <- runDB $ getThreadById threadId

  case maybeThread of
    Nothing -> redirect RedirectTemporary RootR

    Just thread -> do
      form <- runFormPost entryForm
      processForm thread form

processForm :: (Key b Thread, Thread)
               -> ((FormResult EntryForm, Widget), Enctype)
               -> Handler RepHtml

processForm thread ((FormSuccess entry, _), _) = do
  now <- liftIO getCurrentTime
  _   <- runDB $ insert Entry {
                          entryContent = content entry
                          , entryCreated = now
                          , entryUpdated = now
                          , entryThreadId = fst thread
                        }
  redirect RedirectTemporary (ThreadR $ fromKey $ fst thread)

processForm thread ((_, widget), enctype) = do
  entries <- runDB $ getEntriesByThreadId $ fromKey $ fst thread
  defaultLayout $ do
    setTitle "thread"
    $(widgetFile "thread")
    submitWidget
