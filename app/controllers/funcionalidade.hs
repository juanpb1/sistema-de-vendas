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

converterData :: String -> IO (Maybe String)
converterData date = do
  let parsedDate = parseTimeM True Data.Time.Format.defaultTimeLocale "%d%m%Y" date :: Maybe Day
  case parsedDate of
    Just d -> return $ Just (formatTime Data.Time.Format.defaultTimeLocale "%Y-%m-%d" d)
    Nothing -> return Nothing


produtosDisponiveis :: IO ()
produtosDisponiveis = do
    conn <- open "app/db/sistemavendas.db"

    let query = fromString "SELECT idProduto, nome, marca, preco, quantidade FROM Produto WHERE quantidade > 0"
    produtos <- query_ conn query :: IO[(Int, String, String, Double, Int)]
    mapM_ (\(produtoId, nome, marca, preco, quantidade) -> putStrLn $ "ID: " ++ show produtoId ++ 
                                                                    "\nNome: " ++ show nome ++ 
                                                                    "\nMarca: " ++ marca ++ 
                                                                    "\nPreço: R$"++ show preco ++
                                                                    "\nQuantidade: "++ show quantidade ++
                                                                    "\n") produtos

    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

entreData :: IO()
entreData = do 
    conn <- open "app/db/sistemavendas.db"

    putStrLn "Início[YYYY-MM-DD]: "
    dataInicio <- getLine
    dataInicioCon <- converterData dataInicio
    putStrLn "Fim[YYYY-MM-DD]: "
    dataFim <- getLine
    dataFimCon <- converterData  dataFim

    let dados = fromString "SELECT idVenda, idProduto, idCliente, data, qtdVendida, totalVenda FROM Venda WHERE data BETWEEN ? AND ?"
    vendas <- query conn dados (dataInicio, dataFim) :: IO [(Int, Int, Int, String, Int, Double)]
    
    mapM_ (\(idVenda, idProduto, idCliente, dataVenda, qtdVendida, totalVenda) -> putStrLn $ "ID : " ++ show idVenda ++ 
                                                                    "\nID Produto: " ++ show idProduto ++ 
                                                                    "\nID Cliente: "++ show idCliente ++
                                                                    "\nData da venda: "++ show dataVenda ++
                                                                     "\nQuantidade vendida: " ++ show qtdVendida ++ 
                                                                    "\nTotal venda : R$"++ show totalVenda ++
                                                                    "\n") vendas
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
    produtosDisponiveis
    return()
switchOpFuc '2' = do
    entreData
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