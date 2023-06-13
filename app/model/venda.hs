module Model.Venda where

data Venda = Venda {
    idVenda :: Int,
    idProduto :: Int,
    idCliente :: Int,
    dataVenda :: String,
    qtdVendida :: Int,
    totalVenda :: Int
}