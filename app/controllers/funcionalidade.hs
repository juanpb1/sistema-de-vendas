module Controllers.Funcionalidade where

import Model.Venda
import Database.SQLite.Simple
import Database.SQLite.Simple.Types
import Data.List (find)
import Data.String (fromString)
import Data.Time.Format (parseTimeM, formatTime, defaultTimeLocale)
import Data.Time.Calendar (Day)
import System.Locale (defaultTimeLocale)
import Data.Int (Int)
import System.Process
import System.IO
import Controllers.Fornecedor

produtosDisponiveis :: IO ()
produtosDisponiveis = do
    conn <- open "app/db/sistemavendas.db"

    let query = fromString "SELECT idProduto, nome, marca, preco, quantidade FROM Produto WHERE quantidade > 0"
    produtos <- query_ conn query :: IO[(Int, String, String, Double, Int)]
    system "cls"
    putStrLn("=========== PRODUTOS DISPONIVEIS ===========")
    mapM_ (\(produtoId, nome, marca, preco, quantidade) -> do
        putStrLn $ "ID: " ++ show (produtoId :: Int) 
        putStrLn $ "Nome: " ++ show nome  
        putStrLn $ "Marca: " ++ marca 
        putStrLn $ "Preço: R$"++ show (preco :: Double) 
        putStrLn $ "Quantidade: "++ show (quantidade :: Int)
        ) produtos

    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

buscarDataVendas :: IO()
buscarDataVendas = do 
    conn <- open "app/db/sistemavendas.db"

    putStrLn "Início[YYYY-MM-DD]: "
    dataInicio <- getLine
    putStrLn "Fim[YYYY-MM-DD]: "
    dataFim <- getLine

    let dados = fromString "SELECT idVenda, idProduto, idCliente, data, qtdVendida, totalVenda FROM Venda WHERE data BETWEEN ? AND ?"
    vendas <- query conn dados (dataInicio, dataFim) :: IO [(Int, Int, Int, String, Int, Double)]
    
    system "cls"
    putStrLn("=========== Vendas entre "++ dataInicio ++" e "++ dataFim ++ " ===========")
    mapM_ (\(idVenda, idProduto, idCliente, dataVenda, qtdVendida, totalVenda) -> do
        putStrLn $ "ID : " ++ show (idVenda :: Int) 
        putStrLn $ "ID Produto: " ++ show (idProduto :: Int) 
        putStrLn $ "ID Cliente: "++ show (idCliente :: Int) 
        putStrLn $ "Data da venda: "++ show dataVenda 
        putStrLn $ "Quantidade vendida: " ++ show (qtdVendida :: Int) 
        putStrLn $ "Total venda : R$"++ show (totalVenda :: Double)
        putStrLn $ "" 
        ) vendas
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn


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
    putStrLn("=========== Vendas do Cliente: " ++ show (idClienteInput :: Int) ++ " ===========")
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
    produtosDisponiveis
    return()
switchOpFuc '2' = do
    buscarDataVendas
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