module Controllers.Funcionalidade where

import Model.Venda
import Database.SQLite.Simple
import Database.SQLite.Simple.Types
import Data.List (find)
import Data.String (fromString)
import Data.Int (Int)
import System.Process
import System.IO

menuFuncionalidade :: IO()
menuFuncionalidade = do 
    system "cls"
    putStrLn("=========== Menu Funcionalidades ===========")
    putStrLn "1 - Recuperar todos os produtos disponíveis em estoque."
    putStrLn "2 - Recuperar todas as vendas realizadas em um determinado período." 
    putStrLn "3 - Recuperar todas as vendas de um cliente específico."
    putStrLn "4 - Recuperar o total de vendas de um produto específico."
    putStrLn "5 - Recuperar todos os fornecedores cadastrados."
    putStrLn("Opção: ")
    opFuc <- getChar
    getChar
    switchOpFuc opFuc

switchOpFuc :: Char -> IO ()
switchOpFuc '1' = do
    return()
switchOpFuc '2' = do
    return()
switchOpFuc '3' = do
    return()
switchOpFuc '4' = do
    return()
switchOpFuc _ = do
    putStrLn "Opção inválida"