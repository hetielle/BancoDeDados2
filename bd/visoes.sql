use compubras;

-- ex1
CREATE VIEW visao1 AS 
(SELECT c.CodCliente, c.Cidade, c.Uf FROM cliente c);
SELECT * FROM visao1;

-- ex2
CREATE VIEW visao2 AS 
(SELECT ROUND(v.SalarioFixo+(v.SalarioFixo*0.5)+100.00,2) AS salario 
FROM vendedor v WHERE v.FaixaComissao = "D"
ORDER BY v.Nome ASC);
SELECT * FROM visao2;
DROP VIEW visao2;

-- ex3
CREATE VIEW visao3 AS 
(SELECT c.CodCliente, c.Cidade, c.Nome 
FROM cliente c WHERE c.Uf= "RS"
ORDER BY c.Nome ASC, c.Cidade ASC);
SELECT * FROM visao3;

-- ex4
CREATE VIEW visao4 AS
(SELECT ip.CodPedido, COUNT(ip.CodProduto) AS produtos
FROM itempedido ip 
GROUP BY ip.CodProduto, ip.CodPedido
HAVING produtos>10);
SELECT * FROM visao4;
DROP VIEW visao4;

SELECT ip.CodPedido, COUNT(ip.CodProduto) AS produtos
FROM itempedido ip 
GROUP BY ip.CodProduto, ip.CodPedido; 

-- ex5
CREATE VIEW visao5 AS
(SELECT p.CodProduto, p.Descricao, p.ValorUnitario
FROM produto p WHERE p.ValorUnitario>1500.00);
SELECT * FROM visao5;
DROP VIEW visao5;

-- ex6
CREATE VIEW visao6 AS 
(SELECT p.CodProduto, p.Descricao, p.ValorUnitario
FROM produto p 
WHERE p.ValorUnitario<500.00 OR p.ValorUnitario>2500.00);
SELECT * FROM visao6;
DROP VIEW visao6;

-- ex7
CREATE VIEW visao7 AS 
(SELECT c.Uf, COUNT(c.Cidade) AS cidades
FROM cliente c
GROUP BY c.Uf);
SELECT * FROM visao7;
DROP VIEW visao7;

-- ex8
CREATE VIEW visao8 AS 
(SELECT v.CodVendedor, COUNT(p.CodVendedor) AS vendas
FROM vendedor v LEFT JOIN pedido p ON p.CodVendedor = v.CodVendedor
GROUP BY p.CodVendedor, v.CodVendedor
ORDER BY vendas DESC);
DROP VIEW visao8;
SELECT * FROM visao8;

-- ex9
CREATE VIEW visao9 AS
(SELECT c.CodCliente, COUNT(p.CodCliente) AS pedidos
FROM cliente c LEFT JOIN pedido p ON p.CodCliente = c.CodCliente
GROUP BY p.CodCliente, c.CodCliente
ORDER BY pedidos DESC);
DROP VIEW visao9;
SELECT * FROM visao9;

-- ex10
CREATE VIEW visao10 AS 
(SELECT YEAR(p.DataPedido) AS ano, MONTH(p.DataPedido) AS mes, COUNT(p.CodPedido) AS total
FROM pedido p 
GROUP BY ano, mes
ORDER BY total DESC);
SELECT * FROM visao10;
DROP VIEW visao10;

-- ex11
CREATE VIEW visao11 AS
(SELECT v.Nome, v.SalarioFixo FROM vendedor v
WHERE v.SalarioFixo>=1500.00 AND v.CodVendedor IN 
(SELECT p.CodVendedor FROM pedido p
WHERE DATEDIFF(p.PrazoEntrega, p.DataPedido)>15)
ORDER BY v.Nome);
SELECT * FROM visao11;
DROP VIEW visao11;

-- ex12
CREATE VIEW visao12 AS 
(SELECT p.DataPedido, v.Nome AS nomeVendedor, c.Nome AS nomeCliente
FROM vendedor v JOIN  pedido p ON p.CodVendedor = v.CodVendedor
JOIN cliente c ON c.CodCliente = p.CodCliente
WHERE MONTH(p.DataPedido) = 08 AND YEAR(p.DataPedido) = 2015
ORDER BY p.DataPedido ASC);
SELECT * FROM visao12;

-- ex13
CREATE VIEW visao13 AS 
(SELECT p.CodPedido, p.PrazoEntrega, v.Nome AS nomeVendedor,
c.Nome AS nomeCliente, c.Cep, c.Endereco, c.Cidade, c.Uf
FROM vendedor v JOIN  pedido p ON p.CodVendedor = v.CodVendedor
JOIN cliente c ON c.CodCliente = p.CodCliente
WHERE MONTH(p.PrazoEntrega) = 02 AND YEAR(p.PrazoEntrega) = 2015
GROUP BY p.CodPedido
ORDER BY p.PrazoEntrega ASC);
SELECT * FROM visao13;
DROP VIEW visao13;

-- ex14
CREATE VIEW visao14 AS
(SELECT v13.PrazoEntrega, v13.nomeCliente, v13.Cep, v13.Endereco, 
v13.Cidade, v13.Uf FROM visao13 v13
WHERE v13.Uf = "RS");
SELECT * FROM visao14;

-- ex15
CREATE VIEW visao15 AS 
(SELECT v.Nome, ROUND(SUM(temp.valor * 0.10), 2) AS comissao 
FROM vendedor v LEFT JOIN pedido p ON p.CodVendedor = v.CodVendedor JOIN 
(SELECT ip.CodPedido, SUM(pr.ValorUnitario * ip.Quantidade)AS valor 
FROM produto pr JOIN itempedido ip ON ip.CodProduto = pr.CodProduto 
GROUP BY ip.CodPedido)temp ON p.CodPedido = temp.CodPedido GROUP BY v.CodVendedor);
DROP VIEW visao15;
SELECT * FROM visao15;

-- ex16
CREATE VIEW visao16 AS 
(SELECT v.Nome, ROUND(SUM(temp.valor * 0.25), 2) AS comissao 
FROM vendedor v LEFT JOIN pedido p ON p.CodVendedor = v.CodVendedor JOIN 
(SELECT ip.CodPedido, SUM(pr.ValorUnitario * ip.Quantidade) AS valor 
FROM produto pr JOIN itempedido ip ON ip.CodProduto = pr.CodProduto
GROUP BY ip.CodPedido)temp 
ON p.CodPedido = temp.CodPedido 
WHERE YEAR(p.DataPedido) = 2014 AND MONTH(p.DataPedido) = 12
GROUP BY v.CodVendedor 
ORDER BY comissao DESC);
SELECT * FROM visao16;
DROP VIEW visao16;

-- ex17 
CREATE VIEW visao17 AS 
(SELECT v.Nome, COALESCE(COUNT(p.CodPedido),0) AS total
FROM vendedor v LEFT JOIN pedido p ON p.CodVendedor = v.CodVendedor
WHERE YEAR(p.DataPedido)=2015 AND MONTH(p.DataPedido) = 1
GROUP BY v.CodVendedor
ORDER BY total DESC);
SELECT * FROM visao17;
DROP VIEW visao17;

-- ex18
CREATE VIEW visao18 AS 
(SELECT c.Nome, COALESCE(COUNT(p.CodPedido),0) AS total
FROM cliente c LEFT JOIN pedido p ON p.CodCliente = c.CodCliente
GROUP BY c.CodCliente
ORDER BY total DESC);
SELECT * FROM visao18;
DROP VIEW visao18;

-- ex19
CREATE VIEW visao19 AS 
(SELECT pr.CodProduto, pr.Descricao, SUM(ip.Quantidade) AS total
FROM produto pr LEFT JOIN itempedido ip ON ip.CodProduto = pr.CodProduto
GROUP BY pr.CodProduto
ORDER BY total DESC);
SELECT * FROM visao19;
DROP VIEW visao19;

-- ex20
CREATE VIEW visao20 AS 
(SELECT v19.CodProduto, v19.Descricao, v19.total AS totalVendido, 
pr.ValorUnitario, SUM(pr.ValorUnitario*ip.Quantidade) AS totalRendido
FROM visao19 v19 JOIN produto pr ON v19.CodProduto = pr.CodProduto
JOIN itempedido ip ON ip.CodProduto = pr.CodProduto
GROUP BY pr.CodProduto
ORDER BY totalRendido DESC, totalVendido DESC);
SELECT * FROM visao20;
DROP VIEW visao20;