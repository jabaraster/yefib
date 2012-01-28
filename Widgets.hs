module Widgets where

import Import

submitWidget :: GGWidget Jabaraster (GHandler Jabaraster Jabaraster) ()
submitWidget = do
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"
  $(widgetFile "submit")

submitWidget' :: Text -> GGWidget Jabaraster (GHandler Jabaraster Jabaraster) ()
submitWidget' tagId = do
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"
  $(widgetFile "submit2")

data SubmitWidgetContext = SubmitWidgetContext {
  submitTagId :: Text
  , submitOther :: Text
}

submitWidget'' :: SubmitWidgetContext -> GGWidget Jabaraster (GHandler Jabaraster Jabaraster) ()
submitWidget'' context = do
  addScriptRemote "https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"
  $(widgetFile "submit3")
