module Controllers.Fornecedor where

import Model.Fornecedor
import Database.SQLite.Simple
import Database.SQLite.Simple.Types
import Data.String (fromString)

addFornecedor ::  String -> String -> String -> String -> Int -> IO()
addFornecedor nome endereco email telefone idFornecedor = do
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "INSERT INTO Fornecedor (nome, endereco, email, telefone, idFornecedor) VALUES (?, ?, ?, ?, ?)"
    execute conn query (nome, endereco, email, telefone, idFornecedor)
    print "Fornecedor cadastrado"
    close conn

lerFornecedores:: IO()
lerFornecedores = do 
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "SELECT nome, endereco, email, telefone, idFornecedor FROM Fornecedor"
    fornecedores <- query_ conn query :: IO[(String, String, String, String, Int)]
    putStrLn "Fornecedores:"
    mapM_ (\(nome, endereco, email, telefone, idFornecedor) -> putStrLn $ "ID: " ++ show idFornecedor ++ 
                                                                    "\nNome: " ++ show nome ++ 
                                                                    "\nEndereço: " ++ show endereco ++ 
                                                                    "\nEmail: "++ show email ++
                                                                    "\nTelefone: "++ show telefone ++
                                                                    "\n") fornecedores
    close conn

atualizarFornecedor :: Int -> String -> String -> String -> String -> IO()
atualizarFornecedor idFornecedor  nome endereco email telefone = do
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "UPDATE Fornecedor SET nome = ?, endereco = ?, email = ?, telefone = ? WHERE idFornecedor = ?"
    execute conn query (nome, endereco, email, telefone, idFornecedor)
    putStrLn "Fornecedor atualizado"
    close conn

deletarFornecedor :: Int -> IO()
deletarFornecedor idFornecedor = do
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "DELETE FROM Fornecedor WHERE idFornecedor = ?"
    execute conn query (Only idFornecedor)
    putStrLn "Fornecedor removido"
    close conn