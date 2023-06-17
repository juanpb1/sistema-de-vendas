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
import Controllers.Fornecedor

main :: IO ()
main = do
    addFornecedor  "Carvalho" "Rua do Comercio" "carvalho@comercial.com" "(86)996896696"  1
    