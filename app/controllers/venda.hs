module Controllers.Venda where

import Model.Venda
import Database.SQLite.Simple
import Database.SQLite.Simple.Types
import Data.String (fromString)

addVenda ::  Int -> Int -> Int -> String -> Int -> Int -> IO()
addVenda idVenda idProduto idCliente dataVenda qtdVendida totalVenda = do
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "INSERT INTO Venda (idVenda, idProduto, idCliente, data, qtdVendida, totalVenda) VALUES (?, ?, ?, ?, ?, ?)"
    execute conn query (idVenda, idProduto, idCliente, dataVenda, qtdVendida, totalVenda)
    print "Venda realizada"
    close conn

lerVendas:: IO()
lerVendas = do 
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "SELECT idVenda, idProduto, idCliente, data, qtdVendida, totalVenda FROM Venda"
    vendas <- query_ conn query :: IO[(Int, Int, Int, String, Int, Int)]
    putStrLn "Vendas:"
    mapM_ (\(idVenda, idProduto, idCliente, dataVenda, qtdVendida, totalVenda) -> putStrLn $ "ID : " ++ show idVenda ++ 
                                                                    "\nID Produto: " ++ show idProduto ++ 
                                                                    "\nID Cliente: "++ show idCliente ++
                                                                    "\nData da venda: R$"++ show dataVenda ++
                                                                     "\nQuantidade vendida: " ++ show qtdVendida ++ 
                                                                    "\nTotal venda : R$"++ show totalVenda ++
                                                                    "\n") vendas
    close conn

atualizarVenda :: Int -> String -> Int -> IO()
atualizarVenda idVenda dataVenda qtdVendida = do
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "UPDATE Venda SET data = ?, qtdVendida = ? WHERE idVenda = ?"
    execute conn query (dataVenda, qtdVendida, idVenda)
    putStrLn "Venda atualizada"
    close conn

deletarVenda :: Int -> IO()
deletarVenda idVenda = do
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "DELETE FROM Venda WHERE idVenda = ?"
    execute conn query (Only idVenda)
    putStrLn "Venda removida"
    close conn