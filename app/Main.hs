{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Applicative
import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import Database.SQLite.Simple.FromField
import Database.SQLite.Simple.ToRow
import Database.SQLite.Simple.ToField
import Data.Time
import Model.Produto
import Model.Cliente
import Model.Fornecedor
import Model.Venda
import Db.Database
import Controllers.Produto
import Controllers.Cliente

main :: IO ()
main = do
    conn <- open "app/db/tools.db"
    rows <- query_ conn "SELECT * FROM produto" :: IO [Produto]
    mapM_ print rows
    close conn