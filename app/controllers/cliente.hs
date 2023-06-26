module Controllers.Cliente where

import Model.Cliente
import Database.SQLite.Simple
import Database.SQLite.Simple.Types
import Data.String (fromString)
import System.Process
import System.IO

addCliente :: IO()
addCliente = do
    conn <- open "app/db/sistemavendas.db"

    putStrLn("=========== Adicionar Cliente ===========")
    putStrLn "ID: "
    idCliente <- readLn :: IO Int
    putStrLn "Nome: "
    nome <- getLine
    putStrLn "Endereço:"
    endereco <- getLine
    putStrLn "Email:"
    email <- getLine
    putStrLn "Telefone: "
    telefone <- getLine
    
    let query = fromString "INSERT INTO Cliente (nome, endereco, email, telefone, idCliente) VALUES (?, ?, ?, ?, ?)"
    execute conn query (nome, endereco, email, telefone, idCliente)
    print "Cliente cadastrado!"
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

lerClientes:: IO()
lerClientes = do 
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "SELECT nome, endereco, email, telefone, idCliente FROM Cliente"
    clientes <- query_ conn query :: IO[(String, String, String, String, Int)]
    putStrLn "=========== Clientes: ==========="
    mapM_ (\(nome, endereco, email, telefone, idCliente) -> do 
        putStrLn $ "ID: " ++ show (idCliente :: Int) 
        putStrLn $ "Nome: " ++ show nome 
        putStrLn $ "Endereço: " ++ show endereco 
        putStrLn $ "Email: "++ show email 
        putStrLn $ "Telefone: "++ show telefone
        putStrLn $ "\n") clientes
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

atualizarCliente :: IO()
atualizarCliente  = do
    conn <- open "app/db/sistemavendas.db"

    putStrLn("=========== Editar cliente ===========")
    putStrLn "ID: "
    idCliente <- readLn :: IO Int
    putStrLn "Nome: "
    nome <- getLine
    putStrLn "Endereço:"
    endereco <- getLine
    putStrLn "Email:"
    email <- getLine
    putStrLn "Telefone: "
    telefone <- readLn :: IO Int

    let query = fromString "UPDATE Cliente SET nome = ?, endereco = ?, email = ?, telefone = ? WHERE idCliente = ?"
    execute conn query (nome, endereco, email, telefone, idCliente)
    putStrLn "Cliente atualizado!"
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

deletarCliente :: IO()
deletarCliente = do
    conn <- open "app/db/sistemavendas.db"

    putStrLn("=========== Deletar cliente ===========")
    putStrLn "ID: "
    idCliente <- readLn :: IO Int

    let query = fromString "DELETE FROM Cliente WHERE idCliente = ?"
    execute conn query (Only idCliente)
    putStrLn "Cliente removido!"
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

menuCliente :: IO()
menuCliente = do 
    system "cls"
    putStrLn("=========== Menu Clientes ===========")
    putStrLn "1 - Adicionar cliente"
    putStrLn "2 - Exibir clientes" 
    putStrLn "3 - Atualizar cliente"
    putStrLn "4 - Detelar cliente"
    putStrLn("Opção: ")
    opCliente <- getChar
    getChar
    switchOpCliente opCliente

switchOpCliente :: Char -> IO ()
switchOpCliente '1' = do
    addCliente
    return()
switchOpCliente '2' = do
    lerClientes
    return()
switchOpCliente '3' = do
    atualizarCliente
    return()
switchOpCliente '4' = do
    deletarCliente 
    return()
switchOpCliente _ = do
    putStrLn "Opção inválida"