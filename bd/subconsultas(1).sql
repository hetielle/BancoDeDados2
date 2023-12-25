USE compubras;
-- ex1
SELECT c.Nome, c.Endereco, c.Cidade, c.Uf, c.Cep
FROM cliente c WHERE c.CodCliente IN 
(SELECT p.CodCliente FROM pedido p
WHERE YEAR(p.DataPedido) = 2015)
ORDER BY c.Nome ASC;

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

-- ex5
SELECT * FROM cliente c
WHERE c.CodCliente IN 
(SELECT p.CodCliente FROM pedido p 
WHERE p.CodPedido IN 
(SELECT ip.CodPedido FROM itempedido ip GROUP BY ip.CodPedido  
HAVING SUM(ip.Quantidade)>60));

-- ex6
SELECT c.CodCliente, c.Nome, p.CodPedido
FROM cliente c LEFT JOIN pedido p ON p.CodCliente = c.CodCliente
WHERE p.CodVendedor IN
(SELECT v.CodVendedor FROM vendedor v 
WHERE v.FaixaComissao = "A")
ORDER BY c.CodCliente, p.CodPedido;

-- ex7
SELECT c.Nome, c.Endereco, c.Cidade, c.Uf, c.Cep, p.CodPedido, p.PrazoEntrega 
FROM cliente c JOIN pedido p ON c.CodCliente = p.CodCliente 
WHERE p.CodVendedor IN 
(SELECT v.CodVendedor FROM vendedor v
WHERE v.SalarioFixo>=1500.00)
ORDER BY c.CodCliente;

-- ex8
SELECT c.Nome, c.Cidade, c.Uf FROM cliente c
WHERE c.CodCliente IN 
(SELECT p.CodCliente FROM pedido p 
WHERE YEAR(p.DataPedido)=2015)
ORDER BY c.Nome ASC;

-- ex9
SELECT ip.CodPedido, SUM(ip.Quantidade) AS quantidade
FROM itempedido ip
GROUP BY ip.CodPedido
HAVING quantidade>
(SELECT AVG(quant.soma) AS media FROM
(SELECT SUM(quantidade) AS soma from itempedido
GROUP BY itempedido.codpedido) AS quant);

-- ex10 
SELECT c.Nome AS nomeCliente, v.Nome AS nomeVendedor, c.Uf
FROM cliente c 
INNER JOIN pedido p ON p.CodCliente = c.CodCliente
INNER JOIN vendedor v ON p.CodVendedor = v.CodVendedor
WHERE c.Uf = "RS"
AND p.CodPedido IN 
(SELECT MAX(p.CodPedido) FROM pedido p
WHERE p.CodCliente = c.CodCliente)
GROUP BY c.CodCliente
ORDER BY c.Nome ASC, dataPedido DESC;

-- ex11 
SELECT p.Descricao, p.ValorUnitario 
FROM produto p 
WHERE p.ValorUnitario> ALL
(SELECT p.ValorUnitario FROM produto p WHERE p.Descricao LIKE "L%"
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
SELECT ip.CodPedido, SUM(ip.Quantidade) AS total 
FROM itempedido ip
GROUP BY ip.CodPedido HAVING total> 
(SELECT AVG(media) FROM 
(SELECT SUM(ip.Quantidade) AS media
FROM itempedido ip GROUP BY ip.CodPedido) AS temp);

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
(SELECT SUM(p.ValorUnitario) FROM produto p WHERE p.Descricao LIKE "L%"
GROUP BY p.CodProduto)
ORDER BY p.Descricao ASC;

-- ex8 
SELECT pr.CodProduto, pr.Descricao, pr.ValorUnitario
FROM produto pr 
WHERE pr.CodProduto IN
(SELECT ip.CodProduto FROM itempedido ip WHERE ip.Quantidade>9)
ORDER BY pr.ValorUnitario DESC;

-- ex9
SELECT v.CodVendedor, v.Nome FROM vendedor v
WHERE v.CodVendedor NOT IN
(SELECT p.CodVendedor FROM pedido p 
WHERE MONTH(p.PrazoEntrega)="08" AND YEAR(p.PrazoEntrega)="2015")
ORDER BY v.Nome ASC;

-- ex10
SELECT c.CodCliente, c.Nome FROM cliente c
WHERE c.CodCliente IN
(SELECT p.CodCliente FROM pedido p
WHERE MONTH(p.DataPedido)="04" AND YEAR(p.DataPedido)="2014")
ORDER BY c.Nome ASC;

-- LISTA 3 -----------------------------------------------------------------------------------------------
-- ex1
SELECT c.Nome, c.Endereco, c.Cidade, c.Cep FROM cliente c
WHERE c.Uf = "SC" AND c.CodCliente IN
(SELECT p.CodCliente FROM pedido p 
WHERE DATEDIFF(p.PrazoEntrega, p.DataPedido)>= 16 AND DATEDIFF(p.DataPedido, p.PrazoEntrega)< 20);

-- ex2
SELECT c.Nome, c.Endereco, c.Cidade, c.Cep FROM cliente c
WHERE c.Uf = "RS" AND c.CodCliente IN
(SELECT p.CodCliente FROM pedido p 
WHERE YEAR(p.DataPedido)="2015" AND p.CodVendedor IN 
(SELECT v.CodVendedor FROM vendedor v 
WHERE v.Nome LIKE "A%"))
ORDER BY c.Nome ASC;

-- ex3
SELECT v.Nome, v.SalarioFixo, v.FaixaComissao FROM vendedor v
WHERE v.SalarioFixo>=1800.00 AND v.CodVendedor IN
(SELECT p.CodVendedor FROM pedido p 
WHERE MONTH(p.DataPedido)="12" AND YEAR(p.DataPedido)="2014" 
AND p.CodCliente IN 
(SELECT c.CodCliente FROM cliente c WHERE c.Uf = "RS" OR c.Uf = "SC"));

-- ex4
SELECT v.Nome, COUNT(p.CodPedido) AS total 
FROM vendedor v LEFT JOIN pedido p ON p.CodVendedor = v.CodVendedor
WHERE v.CodVendedor IN(SELECT p.CodVendedor FROM pedido p WHERE YEAR(p.DataPedido)="2015")
GROUP BY v.CodVendedor
ORDER BY total DESC;

-- ex6
SELECT v.Nome, ROUND(COALESCE(temp.comissao, 0),2) AS comissao FROM vendedor v LEFT JOIN
(SELECT pe.CodVendedor, (SUM(ip.Quantidade*pr.ValorUnitario))*0.1 AS comissao 
FROM pedido pe
LEFT JOIN itempedido ip ON ip.CodPedido = pe.CodPedido
LEFT JOIN produto pr ON pr.CodProduto = ip.CodProduto
GROUP BY pe.CodVendedor) AS temp
ON temp.CodVendedor = v.CodVendedor
ORDER BY temp.comissao ASC; 

-- ex7
SELECT c.Nome, temp.total FROM cliente c
LEFT JOIN
(SELECT pe.CodCliente, COALESCE(ROUND(SUM(ip.Quantidade*pr.ValorUnitario),2),0) AS total
FROM cliente c LEFT JOIN pedido pe ON c.CodCliente = pe.CodCliente
LEFT JOIN itempedido ip ON ip.CodPedido = pe.CodPedido
LEFT JOIN produto pr ON ip.CodProduto = pr.CodProduto
WHERE YEAR(pe.DataPedido) = 2015
GROUP BY pe.CodCliente) AS temp
ON c.CodCliente = temp.CodCliente
WHERE c.Uf = "RS" OR c.Uf = "SC"
GROUP BY c.CodCliente;

-- ex8
SELECT v.Nome, COALESCE(temp.total,0) FROM vendedor v
LEFT JOIN
(SELECT pe.CodVendedor, ROUND(COALESCE(SUM(ip.Quantidade*pr.ValorUnitario),0),2) AS total
FROM vendedor v LEFT JOIN pedido pe ON v.CodVendedor = pe.CodVendedor
LEFT JOIN itempedido ip ON ip.CodPedido = pe.CodPedido
LEFT JOIN produto pr ON ip.CodProduto = pr.CodProduto
WHERE YEAR(pe.DataPedido) = "2014"
GROUP BY pe.CodVendedor) AS temp
ON v.CodVendedor = temp.CodVendedor
ORDER BY v.Nome ASC;

-- ex9
SELECT p.codproduto, p.descricao, SUM(i.quantidade) total
FROM produto p LEFT JOIN itempedido i ON p.codproduto = i.codproduto
WHERE i.codpedido IN
(SELECT p.codpedido FROM pedido p
WHERE DATE(p.datapedido) >= '2014-08-12' AND DATE(p.datapedido) <= '2014-10-27')
GROUP BY p.codproduto ORDER BY total DESC;


-- ex10
SELECT cliente.Nome, COALESCE(t2014,0),COALESCE(t2015,0),COALESCE((COALESCE(t2015,0) - COALESCE(t2014,0)),0)AS saldo
FROM cliente
LEFT JOIN
(SELECT  pedido.CodCliente, COALESCE(SUM(quantidade*valorUnitario),0) AS t2014
FROM itempedido JOIN produto
ON itempedido.CodProduto = produto.CodProduto
JOIN pedido
ON pedido.CodPedido = itempedido.CodPedido
WHERE YEAR(pedido.DataPedido) = 2014
GROUP BY pedido.CodCliente) temp_2014
ON cliente.CodCliente = temp_2014.CodCliente
LEFT JOIN 
(SELECT  pedido.CodCliente, COALESCE(SUM(quantidade*valorUnitario),0) AS t2015
FROM itempedido JOIN produto
ON itempedido.CodProduto = produto.CodProduto
JOIN pedido
ON pedido.CodPedido = itempedido.CodPedido
WHERE YEAR(pedido.DataPedido) = 2015
GROUP BY pedido.CodCliente) temp_2015
ON cliente.CodCliente = temp_2015.CodCliente
ORDER BY saldo DESC;

-- LISTA 4 ------------------------------------------------------------------------------------------------------------------
-- ex1
SELECT pr.CodProduto, pr.Descricao, pr.ValorUnitario FROM produto pr
WHERE pr.CodProduto IN
(SELECT ip.CodProduto FROM itempedido ip WHERE ip.Quantidade>9);

-- ex2 
SELECT * FROM cliente c
WHERE c.CodCliente IN 
(SELECT p.CodCliente FROM pedido p
WHERE p.DataPedido BETWEEN "2014/09/25" AND "2015/10/05");

-- ex3
SELECT c.CodCliente, c.Nome, c.Endereco, c.Cidade, c.Uf, temp.total
FROM cliente c LEFT JOIN 
(SELECT p.CodCliente, COUNT(p.CodCliente) AS total
FROM pedido p
GROUP BY p.CodCliente) AS temp
ON c.CodCliente = temp.CodCliente
ORDER BY total DESC;

-- ex4
SELECT p.CodPedido, p.PrazoEntrega, p.DataPedido, p.CodCliente, p.CodVendedor, temp.total 
FROM pedido p LEFT JOIN
(SELECT ip.CodPedido, SUM(ip.Quantidade) AS total
FROM itempedido ip
GROUP BY ip.CodPedido) AS temp
ON p.CodPedido = temp.CodPedido
ORDER BY temp.total DESC;

-- ex5
SELECT * FROM produto pr
WHERE pr.CodProduto NOT IN 
(SELECT ip.CodProduto FROM itempedido ip)
ORDER BY pr.Descricao ASC;

-- ex6
SELECT pr.CodProduto, pr.Descricao, pr.ValorUnitario, temp.total
FROM produto pr INNER JOIN
(SELECT ip.CodProduto, SUM(ip.Quantidade) AS total 
FROM itempedido ip 
GROUP BY ip.CodProduto) AS temp
ON pr.CodProduto = temp.CodProduto
ORDER BY temp.total DESC;

-- ex7
SELECT * FROM cliente c
WHERE c.CodCliente IN
(SELECT p.CodCliente FROM pedido p LEFT JOIN itempedido ip ON ip.CodPedido = p.CodPedido
WHERE ip.CodProduto IN 
(SELECT p.CodProduto FROM produto p
WHERE p.ValorUnitario<10.00));

-- ex8
SELECT * FROM vendedor v
WHERE v.CodVendedor IN
(SELECT pe.CodVendedor FROM pedido pe
WHERE pe.CodPedido IN
(SELECT ip.CodPedido FROM itempedido ip
WHERE ip.CodProduto IN
(SELECT pr.CodProduto FROM produto pr
WHERE pr.Descricao LIKE "IPHONE 6 PLUS%")));

-- ex9
SELECT pr.CodProduto, pr.Descricao, pr.ValorUnitario, COUNT(temp.CodPedido) AS total 
FROM produto pr LEFT JOIN
(SELECT ip.CodPedido, ip.CodProduto
FROM itempedido ip)AS temp
ON temp.CodProduto = pr.CodProduto
GROUP BY pr.CodProduto
ORDER BY total DESC;

-- ex10
SELECT pe.CodPedido, pe.PrazoEntrega, pe.DataPedido, pe.CodCliente, pe.codVendedor, temp.total
FROM pedido pe LEFT JOIN 
(SELECT ip.CodPedido, SUM(pr.ValorUnitario*ip.Quantidade) AS total
FROM itempedido ip
LEFT JOIN produto pr ON pr.CodProduto = ip.CodProduto
GROUP BY ip.CodPedido) AS temp
ON temp.CodPedido = pe.CodPedido
ORDER BY temp.total DESC;

-- ex11
SELECT v.Nome, temp.total FROM vendedor v
LEFT JOIN
(SELECT pe.CodVendedor, COUNT(pe.CodPedido) AS total 
FROM pedido pe
GROUP BY pe.CodVendedor) AS temp
ON temp.CodVendedor = v.CodVendedor
ORDER BY temp.total DESC;

-- ex12
SELECT v.Nome, temp.Nome, temp.total
FROM vendedor v JOIN 
(SELECT c.Nome, c.CodCliente, pe.CodVendedor,
SUM(ip.Quantidade*pr.ValorUnitario) AS total
FROM cliente c JOIN pedido pe ON c.CodCliente = pe.CodCliente 
JOIN itempedido ip ON ip.CodPedido = pe.CodPedido 
JOIN produto pr ON ip.CodProduto = pr.CodProduto
GROUP BY pe.Codvendedor, pe.CodCliente) AS temp
ON temp.CodVendedor = v.CodVendedor
ORDER BY total DESC;

-- ex13
SELECT pr.CodProduto, pr.Descricao, pr.ValorUnitario, COALESCE(temp.total,0) AS total 
FROM produto pr JOIN
(SELECT ip.CodProduto, SUM(ip.Quantidade) AS total FROM itempedido ip 
JOIN pedido pe ON ip.CodPedido = pe.CodPedido
AND YEAR(pe.DataPedido)= 2015
GROUP BY ip.CodProduto) AS temp
ON temp.CodProduto = pr.CodProduto
ORDER BY total DESC;

-- ex14
SELECT pr.CodProduto, pr.Descricao, pr.ValorUnitario,
 temp.unidadesVendidas, temp.totalVendido FROM produto pr LEFT JOIN 
(SELECT ip.CodProduto, SUM(ip.Quantidade) AS unidadesVendidas,
SUM(ip.Quantidade*pr.ValorUnitario) AS totalVendido
FROM itempedido ip LEFT JOIN produto pr ON ip.CodProduto = pr.CodProduto
GROUP BY pr.CodProduto) AS temp
ON temp.CodProduto = pr.CodProduto
ORDER BY temp.totalVendido DESC;

-- ex15
SELECT v.Nome, temp.totalVendido FROM vendedor v LEFT JOIN 
(SELECT pe.CodVendedor, SUM(ip.Quantidade*pr.ValorUnitario) AS totalVendido
FROM pedido pe LEFT JOIN itempedido ip ON pe.CodPedido = ip.CodPedido 
LEFT JOIN produto pr ON ip.CodProduto = pr.CodProduto
GROUP BY pe.CodVendedor) AS temp
ON temp.CodVendedor = v.CodVendedor
ORDER BY temp.totalVendido DESC;

-- LISTA 5 ---------------------------------------------------------------------------------------------------------------
-- ex1
SELECT temp.CodPedido, temp.DataPedido, temp.Nome FROM
(SELECT p.CodPedido, p.CodCliente, p.CodVendedor  AS codVP, p.PrazoEntrega, p.DataPedido,
 v.CodVendedor, v.Nome, v.SalarioFixo, v.FaixaComissao FROM pedido p LEFT JOIN vendedor v
ON p.CodVendedor = v.CodVendedor) AS temp;

-- ex2
SELECT temp.CodPedido, temp.DataPedido, temp.Nome FROM
(SELECT p.CodPedido, p.CodCliente AS codCP, p.CodVendedor, p.PrazoEntrega, p.DataPedido, 
c.CodCliente, c.Nome, c.Endereco, c.Cidade, c.Cep, c.Uf, c.Ie 
FROM pedido p LEFT JOIN cliente c ON c.CodCliente = p.CodCliente) AS temp;

-- ex3
SELECT temp.Uf, COUNT(temp.CodPedido) AS quantidade FROM 
(SELECT p.CodPedido, p.CodCliente AS codCP, p.CodVendedor AS codVP, p.PrazoEntrega, p.DataPedido, 
c.CodCliente, c.Nome AS NomeC, c.Endereco, c.Cidade, c.Cep, c.Uf, c.Ie, 
v.CodVendedor, v.Nome AS NomeV, v.SalarioFixo, v.FaixaComissao
FROM vendedor v INNER JOIN pedido p ON p.CodVendedor = v.CodVendedor
INNER JOIN cliente c ON c.CodCliente = p.CodCliente) AS temp
GROUP BY temp.Uf
ORDER BY quantidade DESC;

-- ex4
SELECT temp.NomeV, COUNT(temp.CodPedido) AS quantidade FROM
(SELECT p.CodPedido, p.CodCliente AS codCP, p.CodVendedor AS codVP, p.PrazoEntrega, p.DataPedido, 
c.CodCliente, c.Nome AS NomeC, c.Endereco, c.Cidade, c.Cep, c.Uf, c.Ie, 
v.CodVendedor, v.Nome AS NomeV, v.SalarioFixo, v.FaixaComissao
FROM vendedor v INNER JOIN pedido p ON p.CodVendedor = v.CodVendedor
INNER JOIN cliente c ON c.CodCliente = p.CodCliente) AS temp
GROUP BY temp.CodVendedor, temp.codVP
ORDER BY quantidade DESC;

-- ex5
SELECT temp.NomeC, COUNT(temp.CodPedido) AS quantidade FROM
(SELECT p.CodPedido, p.CodCliente AS codCP, p.CodVendedor AS codVP, p.PrazoEntrega, p.DataPedido, 
c.CodCliente, c.Nome AS NomeC, c.Endereco, c.Cidade, c.Cep, c.Uf, c.Ie, 
v.CodVendedor, v.Nome AS NomeV, v.SalarioFixo, v.FaixaComissao
FROM vendedor v INNER JOIN pedido p ON p.CodVendedor = v.CodVendedor
INNER JOIN cliente c ON c.CodCliente = p.CodCliente) AS temp
GROUP BY temp.CodCliente, temp.codCP
ORDER BY quantidade DESC;

-- ex6
SELECT temp.CodPedido, SUM(temp.Quantidade*temp.ValorUnitario) AS total FROM
(SELECT p.CodPedido, p.CodCliente AS codCP, p.CodVendedor AS codVP, p.PrazoEntrega, p.DataPedido,
ip.CodItemPedido, ip.CodPedido AS CodPeIP, ip.CodProduto AS CodPrIP, ip.Quantidade,
pr.CodProduto, pr.Descricao, pr.ValorUnitario
FROM produto pr INNER JOIN itempedido ip ON pr.CodProduto = ip.CodProduto
INNER JOIN pedido p ON p.CodPedido = ip.CodPedido) AS temp
GROUP BY temp.CodPedido, temp.CodPeIP
ORDER BY temp.CodPedido ASC;

-- ex7
SELECT v.CodVendedor, v.Nome, (v.SalarioFixo + (SUM(temp.Quantidade*temp.ValorUnitario)*0.2)) AS total FROM vendedor v INNER JOIN
(SELECT p.CodPedido, p.CodCliente, p.CodVendedor, p.PrazoEntrega, p.DataPedido,
ip.CodItemPedido, ip.Quantidade,
pr.CodProduto, pr.Descricao, pr.ValorUnitario
FROM produto pr INNER JOIN itempedido ip ON pr.CodProduto = ip.CodProduto
INNER JOIN pedido p ON p.CodPedido = ip.CodPedido) AS temp
ON temp.CodVendedor = v.CodVendedor
WHERE v.FaixaComissao = "A"
AND MONTH(temp.DataPedido) = 04 AND YEAR(temp.DataPedido) = 2016
GROUP BY v.CodVendedor
ORDER BY v.CodVendedor;

-- ex8
SELECT c.CodCliente, c.Nome, SUM(temp.Quantidade*temp.ValorUnitario) AS valorGasto 
FROM cliente c LEFT JOIN 
(SELECT p.CodPedido, p.CodCliente AS codCP, p.CodVendedor AS codVP, p.PrazoEntrega, p.DataPedido,
ip.CodItemPedido, ip.CodPedido AS CodPeIP, ip.CodProduto AS CodPrIP, ip.Quantidade,
pr.CodProduto, pr.Descricao, pr.ValorUnitario
FROM produto pr INNER JOIN itempedido ip ON pr.CodProduto = ip.CodProduto
INNER JOIN pedido p ON p.CodPedido = ip.CodPedido) AS temp
ON temp.CodCP = c.CodCliente
WHERE YEAR(temp.DataPedido) = 2016
GROUP BY c.CodCliente
ORDER BY valorGasto DESC;

-- ex9
SELECT temp.CodProduto, temp.Descricao, SUM(temp.Quantidade) AS total FROM
(SELECT p.CodPedido, p.CodCliente AS codCP, p.CodVendedor AS codVP, p.PrazoEntrega, p.DataPedido,
ip.CodItemPedido, ip.CodPedido AS CodPeIP, ip.CodProduto AS CodPrIP, ip.Quantidade,
pr.CodProduto, pr.Descricao, pr.ValorUnitario
FROM produto pr INNER JOIN itempedido ip ON pr.CodProduto = ip.CodProduto
INNER JOIN pedido p ON p.CodPedido = ip.CodPedido) AS temp
WHERE YEAR(temp.DataPedido) = 2015
GROUP BY temp.CodProduto, temp.CodprIP;

-- ex10
SELECT v.CodVendedor, v.Nome, COUNT(temp.CodPedido) AS total FROM vendedor v JOIN
(SELECT p.CodPedido, p.CodCliente AS codCP, p.CodVendedor AS codVP, p.PrazoEntrega, p.DataPedido,
ip.CodItemPedido, ip.CodPedido AS CodPeIP, ip.CodProduto AS CodPrIP, ip.Quantidade,
pr.CodProduto, pr.Descricao, pr.ValorUnitario
FROM produto pr INNER JOIN itempedido ip ON pr.CodProduto = ip.CodProduto
INNER JOIN pedido p ON p.CodPedido = ip.CodPedido) AS temp
ON temp.CodVP = v.CodVendedor
WHERE temp.Descricao LIKE "PS4%"
GROUP BY v.CodVendedor, temp.CodVP
ORDER BY v.CodVendedor;

-- ex11
SELECT temp.CodPedido, temp.CodProduto, COALESCE(SUM(temp.Quantidade*temp.ValorUnitario),0) AS total FROM
(SELECT p.CodPedido, p.CodCliente, p.CodVendedor, p.PrazoEntrega, p.DataPedido,
ip.CodItemPedido, ip.Quantidade,
pr.CodProduto, pr.Descricao, pr.ValorUnitario
FROM produto pr INNER JOIN itempedido ip ON pr.CodProduto = ip.CodProduto
INNER JOIN pedido p ON p.CodPedido = ip.CodPedido) AS temp
GROUP BY temp.CodPedido, temp.CodProduto
ORDER BY temp.CodPedido;

-- ex12 
SELECT YEAR(temp.DataPedido) AS ano, c.CodCliente, c.Nome, COALESCE(SUM(temp.ValorUnitario*temp.Quantidade),0) AS total
FROM cliente c RIGHT JOIN
(SELECT p.CodPedido, p.CodCliente AS codCP, p.CodVendedor AS codVP, p.PrazoEntrega, p.DataPedido,
ip.CodItemPedido, ip.CodPedido AS CodPeIP, ip.CodProduto AS CodPrIP, ip.Quantidade,
pr.CodProduto, pr.Descricao, pr.ValorUnitario
FROM produto pr INNER JOIN itempedido ip ON pr.CodProduto = ip.CodProduto
INNER JOIN pedido p ON p.CodPedido = ip.CodPedido) AS temp
ON temp.CodCP = c.CodCliente
GROUP BY YEAR(temp.DataPedido), c.CodCliente
ORDER BY YEAR(temp.DataPedido);

-- ex13
SELECT YEAR(temp.DataPedido) AS ano, v.CodVendedor, v.Nome, SUM(temp.ValorUnitario*temp.Quantidade) AS total
FROM vendedor v RIGHT JOIN
(SELECT p.CodPedido, p.CodCliente AS codCP, p.CodVendedor AS codVP, p.PrazoEntrega, p.DataPedido,
ip.CodItemPedido, ip.CodPedido AS CodPeIP, ip.CodProduto AS CodPrIP, ip.Quantidade,
pr.CodProduto, pr.Descricao, pr.ValorUnitario
FROM produto pr INNER JOIN itempedido ip ON pr.CodProduto = ip.CodProduto
INNER JOIN pedido p ON p.CodPedido = ip.CodPedido) AS temp
ON temp.CodVP = v.CodVendedor
GROUP BY v.CodVendedor, temp.CodVP, YEAR(temp.DataPedido)
ORDER BY YEAR(temp.DataPedido), v.CodVendedor;