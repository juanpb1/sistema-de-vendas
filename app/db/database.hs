module Db.Database(withConn)  where

import Database.SQLite.Simple

withConn :: String -> (Connection -> IO ()) -> IO ()
withConn dbName action = do
   conn <- open dbName
   action conn
   close conn