module Handler.Root where

import Import
import Data.Time.Clock (getCurrentTime)
import Model.Accessor

data ThreadForm = ThreadForm {
  title :: Text
} deriving Show

threadForm :: Html -> MForm Jabaraster Jabaraster (FormResult ThreadForm, Widget)
threadForm = renderDivs $ ThreadForm
  <$> areq textField "新規スレッド" Nothing

getRootR :: Handler RepHtml
getRootR = do
  ((_, widget), enctype) <- runFormPost threadForm
  threads <- runDB $ selectList [] [Desc ThreadUpdated]
  defaultLayout $ do
    setTitle "bbs homepage"
    $(widgetFile "homepage")
    $(widgetFile "submit")


postRootR :: Handler RepHtml
postRootR = runFormPost threadForm >>= processForm

processForm :: ((FormResult ThreadForm, Widget), Enctype) -> Handler RepHtml

processForm ((FormSuccess thread, _), _) = do
  now <- liftIO getCurrentTime
  _ <- runDB $ insert Thread {
                        threadTitle = (title thread)
                        , threadCreated = now
                        , threadUpdated = now
                      }
  redirect RedirectTemporary RootR

processForm ((_, widget), enctype) = do
  threads <- runDB $ selectList [] [Desc ThreadUpdated]
  defaultLayout $ do
    setTitle "bbs homepage"
    $(widgetFile "homepage")
    $(widgetFile "submit")
