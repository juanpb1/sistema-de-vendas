{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Applicative
import Database.SQLite.Simple
import Data.Time
import Model.Produto
import Model.Cliente
import Model.Fornecedor
import Model.Venda
import Controllers.Produto
import Controllers.Cliente

main :: IO ()
main = do
    