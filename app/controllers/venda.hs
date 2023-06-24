module Controllers.Venda where

import Model.Venda
import Database.SQLite.Simple
import Database.SQLite.Simple.Types
import Data.List (find)
import Data.String (fromString)
import Data.Int (Int)
import System.Process
import System.IO

addVenda ::  IO()
addVenda  = do

    conn <- open "app/db/sistemavendas.db"

    putStrLn("=========== Realizar venda ===========")
    putStrLn "ID: "
    idVenda <- readLn :: IO Int
    putStrLn "ID do Produto: "
    idProduto <- readLn :: IO Int
    putStrLn "ID do Cliente:"
    idCliente <- readLn :: IO Int
    putStrLn "Data da Venda [01012023]:"
    dataVenda <- getLine
    putStrLn "Quantidade: "
    qtdVendida <- readLn :: IO Int
    
    let queryPreco = fromString "SELECT idProduto, nome, marca, preco, quantidade FROM Produto"
    produtos <- query_ conn queryPreco :: IO[(Int, String, String, Double, Int)]

    let idProdutoDesejado = idProduto
    let precoProduto = case find(\(id, _, _, _, _) -> id == idProdutoDesejado) produtos of
                        Just (_, _, _, preco, _) -> preco
                        Nothing -> 0.0 -- Valor padrão caso o produto não seja encontrado

    let totalVenda = precoProduto * fromIntegral qtdVendida

    let query = fromString "INSERT INTO Venda (idVenda, idProduto, idCliente, data, qtdVendida, totalVenda) VALUES (?, ?, ?, ?, ?, ?)"
    execute conn query (idVenda, idProduto, idCliente, dataVenda, qtdVendida, totalVenda)
    print "Venda realizada!"
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

lerVendas:: IO()
lerVendas = do 
    conn <- open "app/db/sistemavendas.db"

    let query = fromString "SELECT idVenda, idProduto, idCliente, data, qtdVendida, totalVenda FROM Venda"
    vendas <- query_ conn query :: IO[(Int, Int, Int, String, Int, Int)]
    
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

atualizarVenda :: IO()
atualizarVenda = do
    conn <- open "app/db/sistemavendas.db"

    putStrLn("=========== Editar venda ===========")
    putStrLn "ID: "
    idVenda <- readLn :: IO Int
    putStrLn "ID do Produto: "
    idProduto <- readLn :: IO Int
    putStrLn "ID do Cliente:"
    idCliente <- readLn :: IO Int
    putStrLn "Data da Venda [01012023]:"
    dataVenda <- getLine
    putStrLn "Quantidade: "
    qtdVendida <- readLn :: IO Int
    
    let queryPreco = fromString "SELECT idProduto, nome, marca, preco, quantidade FROM Produto"
    produtos <- query_ conn queryPreco :: IO[(Int, String, String, Double, Int)]

    let idProdutoDesejado = idProduto
    let precoProduto = case find(\(id, _, _, _, _) -> id == idProdutoDesejado) produtos of
                        Just (_, _, _, preco, _) -> preco
                        Nothing -> 0.0 

    let totalVenda = precoProduto * fromIntegral qtdVendida

    let query = fromString "UPDATE Venda SET idProduto = ?, idCliente = ?, data = ?, qtdVendida = ?, totalVenda = ? WHERE idVenda = ?"
    execute conn query (idProduto, idCliente, dataVenda, qtdVendida, totalVenda, idVenda)
    print "Venda atualizada!"
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

deletarVenda :: IO()
deletarVenda = do
    conn <- open "app/db/sistemavendas.db"

    putStrLn("=========== Deltar venda ===========")
    putStrLn "ID: "
    idVenda <- readLn :: IO Int

    let query = fromString "DELETE FROM Venda WHERE idVenda = ?"
    execute conn query (Only idVenda)
    putStrLn "Venda removida"
    close conn

menuVenda :: IO()
menuVenda = do 
    system "cls"
    putStrLn("=========== Menu Venda ===========")
    putStrLn "1 - Realizar venda"
    putStrLn "2 - Exibir vendas" 
    putStrLn "3 - Atualizar venda"
    putStrLn "4 - Detelar venda"
    putStrLn("Opção: ")
    opVenda <- getChar
    getChar
    switchOpVenda opVenda

switchOpVenda :: Char -> IO ()
switchOpVenda '1' = do
    addVenda
    return()
switchOpVenda '2' = do
    lerVendas
    return()
switchOpVenda '3' = do
    atualizarVenda
    return()
switchOpVenda '4' = do
    deletarVenda 
    return()
switchOpVenda _ = do
    putStrLn "Opção inválida"