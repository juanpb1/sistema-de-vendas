module Model.Cliente where

data Cliente = Cliente {
    clienteId :: Int,
    nomeCliente :: String,
    endereco :: String, 
    email :: String, 
    telefone :: Int
}