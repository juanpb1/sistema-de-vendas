module Controllers.Cliente where

import Model.Cliente
import Database.SQLite.Simple
import Database.SQLite.Simple.Types
import Data.String (fromString)

addCliente ::  String -> String -> String -> Int -> Int -> IO()
addCliente nome endereco email telefone idCliente = do
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "INSERT INTO Cliente (nome, endereco, email, telefone, idCliente) VALUES (?, ?, ?, ?, ?)"
    execute conn query (nome, endereco, email, telefone, idCliente)
    print "Cliente cadastrado"
    close conn

lerClientes:: IO()
lerClientes = do 
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "SELECT nome, endereco, email, telefone, idCliente FROM Cliente"
    clientes <- query_ conn query :: IO[(String, String, String, Int, Int)]
    putStrLn "Clientes:"
    mapM_ (\(nome, endereco, email, telefone, idCliente) -> putStrLn $ "ID: " ++ show idCliente ++ 
                                                                    "\nNome: " ++ show nome ++ 
                                                                    "\nEndereço: " ++ show endereco ++ 
                                                                    "\nEmail: "++ show email ++
                                                                    "\nTelefone: "++ show telefone ++
                                                                    "\n") clientes
    close conn

atualizarCliente :: Int -> String -> String -> String -> Int -> IO()
atualizarCliente idCliente  nome endereco email telefone = do
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "UPDATE Cliente SET nome = ?, endereco = ?, email = ?, telefone = ? WHERE idCliente = ?"
    execute conn query (nome, endereco, email, telefone, idCliente)
    putStrLn "Cliente atualizado"
    close conn

deletarCliente :: Int -> IO()
deletarCliente idCliente = do
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "DELETE FROM Cliente WHERE idCliente = ?"
    execute conn query (Only idCliente)
    putStrLn "Cliente removido"
    close conn