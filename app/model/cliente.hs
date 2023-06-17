module Model.Cliente where

data Cliente = Cliente {
    nomeCliente :: String,
    endereco :: String, 
    email :: String, 
    telefone :: Int,
    clienteId :: Int
}