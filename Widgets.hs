module Widgets where

import Import
import Data.Text

submitWidget :: GGWidget Jabaraster (GHandler Jabaraster Jabaraster) ()
submitWidget = do
  $(widgetFile "submit")
