module Model.Produto where

data Produto = Produto {
    produtoId :: Int,
    nomeProduto :: String,
    marca :: String,
    preco :: Float,
    quantidade :: Int
}