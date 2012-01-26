{-# OPTIONS_GHC -fno-warn-orphans #-}
module Application
    ( withJabaraster
    , withDevelAppPort
    ) where

import Import
import Settings
import Settings.StaticFiles (staticSite)
import Yesod.Auth
import Yesod.Default.Config
import Yesod.Default.Main
import Yesod.Default.Handlers
import Data.Dynamic (Dynamic, toDyn)
#if DEVELOPMENT
import Yesod.Logger (Logger, logBS, flushLogger)
import Network.Wai.Middleware.RequestLogger (logHandleDev)
#else
import Yesod.Logger (Logger)
import Network.Wai.Middleware.RequestLogger (logStdout)
#endif
import qualified Database.Persist.Base
import Database.Persist.GenericSql (runMigration)

-- Import all relevant handler modules here.
import Handler.Root
import Handler.Thread
import Handler.ThreadDelete
import Handler.Entry
import Handler.EntryDelete

-- This line actually creates our YesodSite instance. It is the second half
-- of the call to mkYesodData which occurs in Foundation.hs. Please see
-- the comments there for more details.
mkYesodDispatch "Jabaraster" resourcesJabaraster

-- This function allocates resources (such as a database connection pool),
-- performs initialization and creates a WAI application. This is also the
-- place to put your migrate statements to have automatic database
-- migrations handled by Yesod.
withJabaraster :: AppConfig DefaultEnv () -> Logger -> (Application -> IO ()) -> IO ()
withJabaraster conf logger f = do
    s <- staticSite
    dbconf <- withYamlEnvironment "config/sqlite.yml" (appEnv conf)
            $ either error return . Database.Persist.Base.loadConfig
    Database.Persist.Base.withPool (dbconf :: Settings.PersistConfig) $ \p -> do
        Database.Persist.Base.runPool dbconf (runMigration migrateAll) p
        let h = Jabaraster conf logger s p
        defaultRunner (f . logWare) h
  where
#ifdef DEVELOPMENT
    logWare = logHandleDev (\msg -> logBS logger msg >> flushLogger logger)
#else
    logWare = logStdout
#endif

-- for yesod devel
withDevelAppPort :: Dynamic
withDevelAppPort = toDyn $ defaultDevelApp withJabaraster
