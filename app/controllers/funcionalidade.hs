module Controllers.Funcionalidade where

import Model.Venda
import Database.SQLite.Simple
import Database.SQLite.Simple.Types
import Data.List (find)
import Data.String (fromString)
import Data.Int (Int)
import System.Process
import System.IO
import Controllers.Fornecedor


totalProduto :: IO()
totalProduto = do
    conn <- open "app/db/sistemavendas.db"

    putStrLn "ID do Produto: "
    idProdutoInput <- readLn :: IO Int

    let dados = fromString "SELECT CASE WHEN SUM(qtdVendida) IS NULL THEN 0 ELSE SUM(qtdVendida) END AS totalVendas FROM Venda WHERE idProduto = ?"

    [Only totalVendas] <- query conn dados (Only idProdutoInput)
    putStrLn $ "Total de vendas do produto: " ++ show (totalVendas :: Int)
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

vendaCliente :: IO ()
vendaCliente = do
    conn <- open "app/db/sistemavendas.db"

    putStrLn "ID do Cliente: "
    idClienteInput <- readLn :: IO Int

    let dados = fromString "SELECT Venda.idVenda, Venda.data, Venda.qtdVendida, Venda.totalVenda \
                                   \ FROM Venda\
                                   \ JOIN Cliente ON Venda.idCliente = Cliente.idCliente\
                                   \ WHERE Cliente.idCliente = ?"

    vendas <- query conn dados (Only idClienteInput)
    putStrLn("=========== VENDAS DO CLIENTE: " ++ show (idClienteInput :: Int) ++ " ===========")
    mapM_ (\(idVenda, dataVenda, qtdVendida, totalVenda) -> do
            putStrLn $ "Venda: " ++ show (idVenda :: Int)
            putStrLn $ "Data: " ++ dataVenda
            putStrLn $ "Quantidade: " ++ show (qtdVendida :: Int)
            putStrLn $ "Total: "++ show (totalVenda :: Int)
            putStrLn "=============================="
        ) vendas
    
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

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
    vendaCliente
    return()
switchOpFuc '4' = do
    totalProduto
    return()
switchOpFuc '5' = do
    lerFornecedores
    return()
switchOpFuc _ = do
    putStrLn "Opção inválida"