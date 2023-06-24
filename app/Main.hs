{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Applicative
import Database.SQLite.Simple
import Data.Time
import Controllers.Produto
import Controllers.Cliente
import Controllers.Fornecedor
import Controllers.Venda
import Controllers.Funcionalidade
import System.Process
import System.IO

main :: IO ()
main = do
  system "cls"
  putStrLn("=========== Gerenciador de Vendas ===========")
  putStrLn("Digite '1' para gerenciar produtos")
  putStrLn("Digite '2' para gerenciar clientes")
  putStrLn("Digite '3' para gerenciar fornecedores")
  putStrLn("Digite '4' para gerenciar vendas")
  putStrLn("Digite '5' para funcionalidades do sistema")
  putStrLn("Digite '0' para finalizar o programa")
  putStrLn("Opção: ")
  op <- getChar
  getChar
  switchOp op
  if op == '0'
    then return ()
    else main

switchOp :: Char -> IO ()
switchOp '1' = do
  menuProduto
  return()
switchOp '2' = do
  menuCliente
  return()
switchOp '3' = do
  menuFornecedor
  return()
switchOp '4' = do
  menuVenda
  return()
switchOp '5' = do
  menuFuncionalidade
  return()
switchOp '0' = do
  putStrLn "Programa encerrado!"
  return()
switchOp _ = do
  putStrLn "Opção inválida"
  
  


 
  

