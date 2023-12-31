module Controllers.Venda where

import Database.SQLite.Simple
import Database.SQLite.Simple.Types
import Data.List (find)
import Data.String (fromString)
import Data.Int (Int)
import System.Process
import System.IO

atualizarQuantidadeProduto :: Int -> Int -> IO Bool
atualizarQuantidadeProduto idProduto quantidadeVendida = do
    conn <- open "app/db/sistemavendas.db"

    let consulta = fromString "SELECT quantidade FROM Produto WHERE idProduto = ?"
    dados <- query conn consulta (Only idProduto) :: IO [Only Int]

    case dados of
        [Only quantidade] ->
            if quantidade >= quantidadeVendida || quantidade /= 0
                then do
                    let query = fromString "UPDATE Produto SET quantidade = ? WHERE idProduto = ?"
                    execute conn query (quantidade - quantidadeVendida, idProduto)
                    close conn
                    return True
                else do
                    close conn
                    putStrLn "Não há quantidade suficiente para a venda."
                    return False
        _ -> do
            close conn
            putStrLn "Produto não encontrado."
            return False

addVenda ::  IO()
addVenda  = do
    conn <- open "app/db/sistemavendas.db"

    system "cls"
    putStrLn("=========== Realizar venda ===========")
    putStrLn "ID: "
    idVenda <- readLn :: IO Int
    putStrLn "ID do Produto: "
    idProduto <- readLn :: IO Int
    putStrLn "ID do Cliente:"
    idCliente <- readLn :: IO Int
    putStrLn "Data da Venda [YYYY-MM-DD]:"
    dataVenda <- getLine
    putStrLn "Quantidade: "
    qtdVendida <- readLn :: IO Int

    vendaRealiza <- atualizarQuantidadeProduto idProduto qtdVendida
    
    if vendaRealiza
        then do
            let queryPreco = fromString "SELECT idProduto, nome, marca, preco, quantidade FROM Produto"
            produtos <- query_ conn queryPreco :: IO [(Int, String, String, Double, Int)]

            let idProdutoDesejado = idProduto
            let precoProduto = case find (\(id, _, _, _, _) -> id == idProdutoDesejado) produtos of
                    Just (_, _, _, preco, _) -> preco
                    Nothing -> 0.0

            let totalVenda = precoProduto * fromIntegral qtdVendida

            let queryInsert = fromString "INSERT INTO Venda (idVenda, idProduto, idCliente, data, qtdVendida, totalVenda) VALUES (?, ?, ?, ?, ?, ?)"
            execute conn queryInsert (idVenda, idProduto, idCliente, dataVenda, qtdVendida, totalVenda)

            putStrLn "Venda realizada!"
            putStrLn "Aperte ENTER para continuar..."
            getLine
        else do
            putStrLn "Não foi possível realizar a venda."
            putStrLn "Aperte ENTER para continuar..."
            getLine

    close conn

lerVendas:: IO()
lerVendas = do 
    conn <- open "app/db/sistemavendas.db"

    let query = fromString "SELECT V.idVenda, P.nome, C.nome, V.data, V.qtdVendida, V.totalVenda \
                                    \ FROM Venda V \  
                                    \ JOIN Produto P ON V.idProduto = P.idProduto\
                                    \ JOIN Cliente C ON V.idCliente = C.idCliente;"
    vendas <- query_ conn query :: IO[(Int, String, String, String, Int, Double)]
    
    system "cls"
    putStrLn("=========== Venda realizadas ===========")
    mapM_ (\(idVenda, nomeProduto, nomeCliente, dataVenda, qtdVendida, totalVenda) -> do
        putStrLn $ "ID : " ++ show (idVenda :: Int)  
        putStrLn $ "Nome do Produto: " ++ show nomeProduto   
        putStrLn $ "Nome do Cliente: "++ show nomeCliente 
        putStrLn $ "Data da venda: "++ show dataVenda
        putStrLn $ "Quantidade vendida: " ++ show (qtdVendida :: Int) 
        putStrLn $ "Total venda : R$"++ show (totalVenda :: Double) 
        putStrLn $ "\n") vendas
    putStrLn "Aperte ENTER para continuar..."
    getLine
    close conn

atualizarVenda :: IO()
atualizarVenda = do
    conn <- open "app/db/sistemavendas.db"

    system "cls"
    putStrLn("=========== Editar venda ===========")
    putStrLn "ID: "
    idVenda <- readLn :: IO Int
    putStrLn "ID do Produto: "
    idProduto <- readLn :: IO Int
    putStrLn "ID do Cliente:"
    idCliente <- readLn :: IO Int
    putStrLn "Data da Venda [YYYY-MM-DD]:"
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

    system "cls"
    putStrLn("=========== Deletar venda ===========")
    putStrLn "ID: "
    idVenda <- readLn :: IO Int

    let query = fromString "DELETE FROM Venda WHERE idVenda = ?"
    execute conn query (Only idVenda)
    putStrLn "Venda removida!"
    putStrLn "Aperte ENTER para continuar..."
    getLine
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