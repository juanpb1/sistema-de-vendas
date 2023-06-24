module Controllers.Produto where

import Model.Produto
import Database.SQLite.Simple
import Database.SQLite.Simple.Types
import Data.String (fromString)
import System.Process
import System.IO

addProduto :: IO()
addProduto = do
    putStrLn("=========== Adicionar produto ===========")
    conn <- open "app/db/sistemavendas.db"
    putStrLn "ID: "
    idProduto <- readLn :: IO Int
    putStrLn "Nome:"
    nome <- getLine
    putStrLn "Marca:"
    marca <- getLine
    putStrLn "Preço: "
    preco <- readLn :: IO Float
    putStrLn "Quantidade: "
    quantidade <- readLn :: IO Int

    let query = fromString "INSERT INTO Produto (idProduto, nome, marca, preco, quantidade) VALUES (?, ?, ?, ?, ?)"
    execute conn query (idProduto, nome, marca, preco, quantidade)
    print "Produto adicionado!"
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

lerProdutos :: IO()
lerProdutos = do 
    putStrLn("=========== Lista de produtos ===========")
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "SELECT idProduto, nome, marca, preco, quantidade FROM Produto"
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

atualizarProduto :: IO()
atualizarProduto = do
    putStrLn("=========== Editar produto ===========")
    conn <- open "app/db/sistemavendas.db"
    putStrLn "ID: "
    idProduto <- readLn :: IO Int
    putStrLn "Nome:"
    nome <- getLine
    putStrLn "Marca:"
    marca <- getLine
    putStrLn "Preço: "
    preco <- readLn :: IO Float
    putStrLn "Quantidade: "
    quantidade <- readLn :: IO Int
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "UPDATE Produto SET nome = ?, marca = ?, preco = ?, quantidade = ? WHERE idProduto = ?"
    execute conn query (nome, marca, preco, quantidade, idProduto)
    putStrLn "Produto atualizado"
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn


deletarProduto :: IO()
deletarProduto = do
    putStrLn("=========== Deletar produto ===========")
    conn <- open "app/db/sistemavendas.db"
    putStrLn "ID: "
    idProduto <- readLn :: IO Int
    let query = fromString "DELETE FROM Produto WHERE idProduto = ?"
    execute conn query (Only idProduto)
    putStrLn "Produto removido"
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

menuProduto :: IO()
menuProduto = do 
    system "cls"
    putStrLn("=========== Menu Produtos ===========")
    putStrLn "1 - Adicionar produto"
    putStrLn "2 - Exibir produtos" 
    putStrLn "3 - Atualizar produto"
    putStrLn "4 - Detelar produto"
    putStrLn("Opção: ")
    opProduto <- getChar
    getChar
    switchOpProduto opProduto

switchOpProduto :: Char -> IO ()
switchOpProduto '1' = do
    addProduto 
    return()
switchOpProduto '2' = do
    lerProdutos 
    return()
switchOpProduto '3' = do
    atualizarProduto 
    return()
switchOpProduto '4' = do
    deletarProduto 
    return()
switchOpProduto _ = do
    putStrLn "Opção inválida"