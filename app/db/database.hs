module Db.Database(withConn)  where

import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import Database.SQLite.Simple.FromField
import Database.SQLite.Simple.ToRow
import Database.SQLite.Simple.ToField

withConn :: String -> (Connection -> IO ()) -> IO ()
withConn dbName action = do
   conn <- open dbName
   action conn
   close conn