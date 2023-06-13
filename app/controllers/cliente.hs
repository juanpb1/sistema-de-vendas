module Controllers.Cliente where

import Model.Cliente

instance Show Cliente where
    show cliente = mconcat [ show $ clienteId cliente,
                            ".) ",
                            nomeCliente cliente,
                            "\n Produtos:",
                            endereco cliente,
                            "\n Email: ",
                            show $ email cliente,
                            "\n Telefone: ",
                            show $ telefone cliente,
                            "\n "]