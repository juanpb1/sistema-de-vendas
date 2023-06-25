BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "Produto" (
	"idProduto"	INTEGER NOT NULL,
	"nome"	TEXT NOT NULL,
	"marca"	TEXT NOT NULL,
	"preco"	REAL,
	"quantidade"	INTEGER,
	PRIMARY KEY("idProduto")
);
CREATE TABLE IF NOT EXISTS "Fornecedor" (
	"idFornecedor"	INTEGER NOT NULL,
	"nome"	TEXT NOT NULL,
	"endereco"	TEXT,
	"email"	TEXT,
	"telefone"	TEXT,
	PRIMARY KEY("idFornecedor")
);
CREATE TABLE IF NOT EXISTS "Venda" (
	"idVenda"	INTEGER,
	"idProduto"	INTEGER,
	"idCliente"	INTEGER,
	"data"	DATE,
	"qtdVendida"	INTEGER,
	"totalVenda"	REAL
);
CREATE TABLE IF NOT EXISTS "Cliente" (
	"idCliente"	INTEGER,
	"nome"	TEXT,
	"endereco"	TEXT,
	"email"	TEXT,
	"telefone"	TEXT,
	PRIMARY KEY("idCliente")
);
INSERT INTO "Produto" ("idProduto","nome","marca","preco","quantidade") VALUES (1,'Arroz
','Bijú',7.5,10),
 (2,'Feijão','BomD+',8.5,5),
 (3,'Massa de Milho','Flocão',2.0,15);
INSERT INTO "Venda" ("idVenda","idProduto","idCliente","data","qtdVendida","totalVenda") VALUES (1,2,1,'2023-07-01',4,50.0);
INSERT INTO "Cliente" ("idCliente","nome","endereco","email","telefone") VALUES (1,'Marcos','Rua Cocal de telha, 1234','marcos@email.com','(86)996685789'),
 (2,'Alan','Rua Barro fundo, 3214','alan@email.com','(98)998556696');
COMMIT;
