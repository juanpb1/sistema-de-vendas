module Model.Fornecedor where

data Fornecedor = Fornecedor {
    fornecedorId :: Int,
    nomeFornecedor :: String,
    enderecoFornecedor :: String,
    emailFornecedor :: String,
    telefoneFornecedor :: String
}