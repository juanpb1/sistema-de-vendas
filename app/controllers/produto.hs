module Controllers.Produto where

import Model.Produto
import Database.SQLite.Simple
import Database.SQLite.Simple.Types
import Data.String (fromString)


addProduto :: Int -> String -> String -> Double -> Int -> IO()
addProduto produtoId produtoNome marca preco quantidade = do
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "INSERT INTO Produto (idProduto, nome, marca, preco, quantidade) VALUES (?, ?, ?, ?, ?)"
    execute conn query (produtoId, produtoNome, marca, preco, quantidade)
    print "Produto adicionado"
    close conn

lerProdutos :: IO()
lerProdutos = do 
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "SELECT idProduto, nome, marca, preco, quantidade FROM Produto"
    produtos <- query_ conn query :: IO[(Int, String, String, Double, Int)]
    putStrLn "Produtos:"
    mapM_ (\(produtoId, nome, marca, preco, quantidade) -> putStrLn $ "ID: " ++ show produtoId ++ 
                                                                    "\nNome: " ++ show nome ++ 
                                                                    "\nMarca: " ++ marca ++ 
                                                                    "\nPreço: R$"++ show preco ++
                                                                    "\nQuantidade: "++ show quantidade ++
                                                                    "\n") produtos
    close conn

atualizarProduto :: Int -> String -> String -> Double -> Int -> IO()
atualizarProduto produtoId produtoNome marca preco quantidade = do
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "UPDATE Produto SET nome = ?, marca = ?, preco = ?, quantidade = ? WHERE idProduto = ?"
    execute conn query (produtoNome, marca, preco, quantidade, produtoId)
    putStrLn "Produto atualizado"
    close conn


deletarProduto :: Int -> IO()
deletarProduto produtoId = do
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "DELETE FROM Produto WHERE idProduto = ?"
    execute conn query (Only produtoId)
    putStrLn "Produto removido"
    close conn
