module Model.Accessor (
  getThreadById
  , getEntriesByThreadId
  , getEntryById
  , toKey
  , fromKey
) where

import Import
import Database.Persist.Base
import Data.Int

getThreadById threadId = selectFirst [ThreadId ==. toKey threadId] []

getEntryById entryId = selectFirst [EntryId ==. toKey entryId] []

getEntriesByThreadId threadId = selectList [EntryThreadId ==. toKey threadId] [Desc EntryUpdated]

toKey :: Integer -> Key b e
toKey value = Key { unKey = PersistInt64 $ read $ show value }

fromKey :: Key backend entity -> Integer
fromKey key = case (fromPersistValue $ unKey key) :: Either String Int64 of
                       Left  s -> read s
                       Right i -> read $ show i
