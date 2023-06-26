module Controllers.Fornecedor where

import Model.Fornecedor
import Database.SQLite.Simple
import Database.SQLite.Simple.Types
import Data.String (fromString)
import System.Process
import System.IO

addFornecedor :: IO()
addFornecedor = do
    conn <- open "app/db/sistemavendas.db"

    putStrLn("=========== Adicionar fornecedor ===========")
    putStrLn "ID: "
    idFornecedor <- readLn :: IO Int
    putStrLn "Nome: "
    nome <- getLine
    putStrLn "Endereço:"
    endereco <- getLine
    putStrLn "Email:"
    email <- getLine
    putStrLn "Telefone: "
    telefone <- readLn :: IO Int

    let query = fromString "INSERT INTO Fornecedor (nome, endereco, email, telefone, idFornecedor) VALUES (?, ?, ?, ?, ?)"
    execute conn query (nome, endereco, email, telefone, idFornecedor)
    print "Fornecedor cadastrado!"
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

lerFornecedores:: IO()
lerFornecedores = do 
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "SELECT nome, endereco, email, telefone, idFornecedor FROM Fornecedor"
    fornecedores <- query_ conn query :: IO[(String, String, String, String, Int)]
    putStrLn "=========== Fornecedores: ==========="
    mapM_ (\(nome, endereco, email, telefone, idFornecedor) -> do  
        putStrLn $ "ID: " ++ show (idFornecedor :: Int)  
        putStrLn $ "Nome: " ++ show nome 
        putStrLn $ "Endereço: " ++ show endereco 
        putStrLn $ "Email: "++ show email 
        putStrLn $"Telefone: "++ show telefone
        putStrLn $"\n") fornecedores
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

atualizarFornecedor :: IO()
atualizarFornecedor = do
    conn <- open "app/db/sistemavendas.db"

    putStrLn("=========== Editar fornecedor ===========")
    putStrLn "ID: "
    idFornecedor <- readLn :: IO Int
    putStrLn "Nome: "
    nome <- getLine
    putStrLn "Endereço:"
    endereco <- getLine
    putStrLn "Email:"
    email <- getLine
    putStrLn "Telefone: "
    telefone <- getLine

    let query = fromString "UPDATE Fornecedor SET nome = ?, endereco = ?, email = ?, telefone = ? WHERE idFornecedor = ?"
    execute conn query (nome, endereco, email, telefone, idFornecedor)
    putStrLn "Fornecedor atualizado!"
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

deletarFornecedor :: IO()
deletarFornecedor = do
    conn <- open "app/db/sistemavendas.db"

    putStrLn("=========== Deletar fornecedor ===========")
    putStrLn "ID: "
    idFornecedor <- readLn :: IO Int

    let query = fromString "DELETE FROM Fornecedor WHERE idFornecedor = ?"
    execute conn query (Only idFornecedor)
    putStrLn "Fornecedor removido!"
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

menuFornecedor:: IO()
menuFornecedor = do 
    system "cls"
    putStrLn("=========== Menu Fornecedor ===========")
    putStrLn "1 - Adicionar fornecedor"
    putStrLn "2 - Exibir fornecedores" 
    putStrLn "3 - Atualizar fornecedor"
    putStrLn "4 - Detelar fornecedor"
    putStrLn("Opção: ")
    opFornecedor <- getChar
    getChar
    switchOpFornecedor opFornecedor

switchOpFornecedor :: Char -> IO ()
switchOpFornecedor '1' = do
    addFornecedor
    return()
switchOpFornecedor '2' = do
    lerFornecedores
    return()
switchOpFornecedor '3' = do
    atualizarFornecedor
    return()
switchOpFornecedor '4' = do
    deletarFornecedor 
    return()
switchOpCliente _ = do
    putStrLn "Opção inválida"