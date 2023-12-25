USE compubras;

-- ex2
SELECT p.Descricao, p.ValorUnitario FROM produto p 
WHERE p.CodProduto IN (SELECT ip.CodProduto FROM itempedido ip WHERE ip.Quantidade >=5 
AND ip.Quantidade<=7)
ORDER BY p.ValorUnitario DESC;

-- ex3
SELECT COALESCE(SUM(p.CodCliente = c.CodCliente),0) AS total FROM pedido p
LEFT JOIN cliente c ON p.CodCliente = c.CodCliente 
WHERE c.CodCliente IN  
(SELECT c.CodCliente FROM cliente c WHERE c.Uf = "RS" OR c.Uf = "SC");

-- ex4
SELECT pr.CodProduto, pr.Descricao, pr.ValorUnitario FROM produto pr 
WHERE pr.CodProduto IN (SELECT ip.CodProduto FROM itempedido ip LEFT JOIN pedido pe
ON ip.CodPedido = pe.CodPedido WHERE pe.PrazoEntrega BETWEEN "2014/12/01" AND "2015/01/31")
ORDER BY pr.ValorUnitario DESC;

-- ex5 vindo null (having e s/ join
SELECT * FROM cliente c 
WHERE c.CodCliente IN 
(SELECT p.CodCliente FROM pedido p 
LEFT JOIN itempedido ip ON ip.CodPedido = p.CodPedido 
WHERE ip.Quantidade>60) 
ORDER BY c.CodCliente ASC;

-- ex6 ?
SELECT c.CodCliente, c.Nome 
FROM cliente c 
WHERE c.CodCliente IN
(SELECT p.CodCliente FROM pedido p
LEFT JOIN itempedido ip ON ip.CodPedido = p.CodPedido 
WHERE p.CodVendedor IN
(SELECT v.CodVendedor FROM vendedor v 
WHERE v.FaixaComissao = "A"))
ORDER BY c.Nome, p.CodPedido;

-- ex7 ta faltando linha
SELECT c.Nome, c.Endereco, c.Cidade, c.Uf, c.Cep, p.CodPedido, p.PrazoEntrega 
FROM cliente c LEFT JOIN pedido p ON c.CodCliente = p.CodCliente 
LEFT JOIN vendedor v ON v.CodVendedor = p.CodVendedor
WHERE v.CodVendedor IN 
(SELECT v.CodVendedor FROM vendedor v
WHERE v.SalarioFixo>1500.00)
ORDER BY c.CodCliente;

-- ex8
SELECT c.Nome, c.Cidade, c.Uf FROM cliente c
WHERE c.CodCliente IN 
(SELECT p.CodCliente FROM pedido p 
WHERE YEAR(p.DataPedido)=2015)
ORDER BY c.Nome ASC;

-- ex9 sum
SELECT p.CodPedido, SUM(ip.Quantidade) AS quantidades
FROM pedido p LEFT JOIN itempedido ip ON ip.CodPedido = p.CodPedido
WHERE quantidades> ANY
(ip.Quantidade/quantidades)
GROUP BY ip.CodProduto
ORDER BY p.CodPedido ASC;

-- ex10 vendedor errado
SELECT c.Nome AS nomeCliente, v.Nome AS nomeVendedor, c.Uf
FROM cliente c 
INNER JOIN pedido p ON p.CodCliente = c.CodCliente
INNER JOIN vendedor v ON p.CodVendedor = v.CodVendedor
WHERE c.Uf = "RS"
AND p.DataPedido IN 
(SELECT MIN(p.DataPedido) FROM pedido p
WHERE p.CodCliente = c.CodCliente)
GROUP BY c.CodCliente
ORDER BY c.Nome ASC, dataPedido DESC;

-- ex11 select
SELECT p.Descricao, p.ValorUnitario 
FROM produto p 
WHERE p.ValorUnitario>
(SELECT SUM(p.ValorUnitario) FROM produto p WHERE p.Descricao LIKE "L%"
GROUP BY p.CodProduto)
ORDER BY p.Descricao ASC;

-- ex12
SELECT p.CodProduto, p.Descricao, p.ValorUnitario
FROM produto p 
WHERE p.CodProduto IN 
(SELECT ip.CodProduto FROM itempedido ip 
WHERE ip.Quantidade>9)
ORDER BY  p.CodProduto ASC, p.ValorUnitario DESC;

-- ex13
SELECT v.CodVendedor, v.Nome
FROM vendedor v 
WHERE v.CodVendedor NOT IN 
(SELECT p.CodVendedor FROM pedido p 
WHERE MONTH(p.PrazoEntrega)="08" AND YEAR(p.PrazoEntrega)="2015")
ORDER BY v.CodVendedor ASC, v.Nome ASC;

-- ex14
SELECT c.CodCliente, c.Nome
FROM cliente c
WHERE c.CodCliente IN
(SELECT p.CodCliente FROM pedido p 
WHERE MONTH(p.DataPedido)="04" AND YEAR(p.DataPedido)="2014")
ORDER BY c.Nome ASC;


-- LISTA 2 -------------------------------------------------------------------------------
-- ex1
SELECT c.CodCliente, c.Nome, p.CodPedido
FROM cliente c LEFT JOIN pedido p ON p.CodCliente = c.CodCliente
WHERE p.CodVendedor IN 
(SELECT v.CodVendedor FROM vendedor v 
WHERE v.FaixaComissao = "A")
ORDER BY c.Nome ASC, p.CodPedido;

-- ex2
SELECT c.Nome, c.Endereco, c.Cidade, c.Uf, c.Cep, p.CodPedido
FROM cliente c LEFT JOIN pedido p ON c.CodCliente = p.CodCliente 
LEFT JOIN vendedor v ON v.CodVendedor = p.CodVendedor
WHERE v.CodVendedor NOT IN 
(SELECT v.CodVendedor FROM vendedor v
WHERE v.SalarioFixo<1500.00)
ORDER BY c.CodCliente;

-- ex3
SELECT c.Nome, c.Cidade, c.Uf
FROM cliente c 
WHERE c.CodCliente IN 
(SELECT p.CodCliente FROM pedido p
WHERE YEAR(p.DataPedido)=2015)
ORDER BY c.Nome ASC;

-- ex4
SELECT p.CodPedido;

-- ex6
SELECT c.Nome, c.Uf, v.Nome AS vNome
FROM cliente c 
INNER JOIN pedido p ON p.CodCliente = c.CodCliente
INNER JOIN vendedor v ON p.CodVendedor = v.CodVendedor
WHERE c.Uf = "SC"
AND p.DataPedido IN 
(SELECT MIN(p.DataPedido) FROM pedido p
WHERE p.CodCliente = c.CodCliente)
GROUP BY c.CodCliente, v.CodVendedor, c.Uf
ORDER BY c.Nome ASC, dataPedido DESC;

-- ex7
SELECT p.Descricao, p.ValorUnitario
FROM produto p 
WHERE p.ValorUnitario> ALL
(SELECT SUM(p.ValorUnitario) FROM produto p WHERE p.Descricao LIKE "L%")
ORDER BY p.Descricao ASC;