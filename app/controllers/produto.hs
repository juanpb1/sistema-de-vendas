module Controllers.Produto where

import Model.Produto
import Database.SQLite.Simple
import qualified Data.Text as T
import Database.SQLite.Simple.Types
import Data.String (fromString)
import Database.SQLite.Simple.FromRow
import Database.SQLite.Simple.FromField
import Database.SQLite.Simple.ToRow
import Database.SQLite.Simple.ToField

--Faz a conversão entre os dados Haskell e o banco de dados
instance FromRow Produto where
    fromRow = Produto <$> field <*> field <*> field <*> field <*> field

instance ToRow Produto where
    toRow (Produto id' nome' marca' preco' quantidade') = toRow (id', nome', marca', preco', quantidade')


addProduto :: Int -> String -> String -> Double -> Int -> IO ()
addProduto produtoId produtoNome marca preco quantidade = do
    conn <- open "app/db/sistemavendas.db"
    let query = fromString "INSERT INTO Produto (idProduto, nome, marca, preco, quantidade) VALUES (?, ?, ?, ?, ?)"
    execute conn query (produtoId, produtoNome, marca, preco, quantidade)
    print "Produto adicionado"
    close conn

instance Show Produto where
    show produto = mconcat [ show $ produtoId produto,
                            ".) ",
                            nomeProduto produto,
                            "\nMarca: ",
                            marca produto,
                            "\nPreço: ",
                            show $ preco produto,
                            "\nQuantidade: ",
                            show $ quantidade produto,
                            "\n "]