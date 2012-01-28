module Handler.ThreadDelete where

import Import
import Model.Accessor

postThreadDeleteR :: Integer -> Handler RepHtml
postThreadDeleteR threadId = do
  runDB $ delete (toKey threadId :: Key b Thread)
  runDB $ deleteWhere [EntryThreadId ==. toKey threadId]
  redirect RedirectSeeOther RootR


