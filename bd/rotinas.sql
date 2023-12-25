USE compubras;

-- ex1: Retorne o número mais o nome do mês em português (1 - Janeiro) 
-- de acordo com o parâmetro informado que deve ser uma data. Para testar,
-- crie uma consulta que retorne o cliente e mês de venda (número e nome do mês)
DELIMITER $$
CREATE FUNCTION ex1 (DataPedido	date)RETURNS varchar(30) DETERMINISTIC
BEGIN 
DECLARE mes INT;
SELECT MONTH(DataPedido) INTO mes;
CASE mes
	WHEN 01 THEN RETURN('1-Janeiro');
	WHEN 02 THEN RETURN('2-Fevereiro');
    WHEN 03 THEN RETURN('3-Março');
    WHEN 04 THEN RETURN('4-Abril');
    WHEN 05 THEN RETURN('5-Maio');
    WHEN 06 THEN RETURN('6-Junho');
    WHEN 07 THEN RETURN('7-Julho');
    WHEN 08 THEN RETURN('8-Agosto');
    WHEN 09 THEN RETURN('9-Setembro');
    WHEN 10 THEN RETURN('10-Outubro');
    WHEN 11 THEN RETURN('11-Novembro');
    WHEN 12 THEN RETURN('12-Dezembro');
END CASE;
END$$
DELIMITER ;
DROP FUNCTION ex1;
SELECT c.Nome, ex1(p.DataPedido) 
FROM cliente c JOIN pedido p 
ON c.CodCliente = p.CodCliente;

-- ex2 Retorne o número mais o nome do dia da semana (0 - Segunda) em português, como parâmetro de
-- entrada receba uma data. Para testar, crie uma consulta que retorne o número do pedido, nome do
-- cliente e dia da semana para entrega (função criada)
DELIMITER $$
CREATE FUNCTION ex2 (DataPedido	date)RETURNS varchar(30) DETERMINISTIC
BEGIN
DECLARE diaSemana INT;
SELECT WEEKDAY(DataPedido) INTO diaSemana;
CASE diaSemana
	WHEN 0 THEN RETURN('0-Segunda');
	WHEN 1 THEN RETURN('1-Terça');
    WHEN 2 THEN RETURN('2-Quarta');
    WHEN 3 THEN RETURN('3-Quinta');
    WHEN 4 THEN RETURN('4-Sexta');
    WHEN 5 THEN RETURN('5-Sábado');
    WHEN 6 THEN RETURN('6-Domingo');
END CASE;
END$$
DELIMITER ;
DROP FUNCTION ex2;
SELECT p.CodPedido, c.Nome, ex2(p.DataPedido) 
FROM cliente c JOIN pedido p 
ON c.CodCliente = p.CodCliente;

-- ex3: Crie uma função para retornar o gentílico dos clientes de acordo com o estado onde moram
-- (gaúcho, catarinense ou paranaense), o parâmetro de entrada deve ser a sigla do estado. Para
-- testar a função crie uma consulta que liste o nome do cliente e gentílico (função criada).
DELIMITER $$
CREATE FUNCTION ex3 (Uf	CHAR(2))RETURNS varchar(30) DETERMINISTIC
BEGIN 
CASE Uf
	WHEN Uf = 'AC' THEN RETURN('ACRIANO');
	WHEN Uf = 'AL' THEN RETURN('ALAGOANO');
    WHEN Uf = 'AP' THEN RETURN('AMAPAENSE');
    WHEN Uf = 'AM' THEN RETURN('AMAZONENSE');
    WHEN Uf = 'BA' THEN RETURN('BAIANO');
    WHEN Uf = 'CE' THEN RETURN('CEARENSE');
    WHEN Uf = 'DF' THEN RETURN('BRASILIENSE');
    WHEN Uf = 'ES' THEN RETURN('CAPIXABA');
    WHEN Uf = 'GO' THEN RETURN('GOIANO');
    WHEN Uf = 'MA' THEN RETURN('MARANHENSE');
    WHEN Uf = 'MT' THEN RETURN('MATO-GROSSENSE');
    WHEN Uf = 'MS' THEN RETURN('SUL-MATO-GROSSENSE');
    WHEN Uf = 'MG' THEN RETURN('MINEIRO');
    WHEN Uf = 'PA' THEN RETURN('PARAENSE');
    WHEN Uf = 'PB' THEN RETURN('PARAIBANO');
    WHEN Uf = 'PR' THEN RETURN('PARANAENSE');
    WHEN Uf = 'PE' THEN RETURN('PERNANBUCO');
    WHEN Uf = 'PI' THEN RETURN('PIAUIENSE');
    WHEN Uf = 'RJ' THEN RETURN('FLUMINENSE');
    WHEN Uf = 'RN' THEN RETURN('POTIGUAR');
    WHEN Uf = 'RS' THEN RETURN('GAÚCHO');
    WHEN Uf = 'RO' THEN RETURN('RONDONIANO');
    WHEN Uf = 'RR' THEN RETURN('RORAIMENSE');
    WHEN Uf = 'SC' THEN RETURN('CATARINENSE');
    WHEN Uf = 'SP' THEN RETURN('PAULISTA');
    WHEN Uf = 'SE' THEN RETURN('SERGIPANO');
    WHEN Uf = 'TO' THEN RETURN('TOCANTINENSE');
END CASE;
END$$
DELIMITER ;
SELECT c.Nome, ex3(c.Uf) AS Gentilicopedido
FROM cliente c ;

-- ex4: Crie uma função que retorne a Inscrição Estadual no formato #######-##. Para testar a função
-- criada exiba os dados do cliente com a IE formatada corretamente utilizando a função criada.
-- fazer
DELIMITER $$
CREATE FUNCTION ex4 (Ie VARCHAR(12))RETURNS varchar(30) DETERMINISTIC
BEGIN 
RETURN CONCAT(SUBSTRING(Ie, 1, 7), "-",SUBSTRING(Ie, 8, 9));
END$$
DELIMITER ;
DROP FUNCTION ex4;
SELECT c.Nome, c.Endereco, c.Cidade, c.Uf, c.Cep, ex4(c.Ie) AS Ie
FROM cliente c;

-- ex5: Crie uma função que retorne o tipo de envio do pedido, se for até 3 dias será enviado por SEDEX,
-- se for entre 3 e 7 dias deverá ser enviado como encomenda normal, caso seja maior que este prazo
-- deverá ser utilizado uma encomenda não prioritária. Como dados de entrada recebe a data do
-- pedido e o prazo de entrega e o retorno será um varchar. Note que para criar esta função você
-- deverá utilizar a cláusula IF.
DELIMITER $$
CREATE FUNCTION ex5 (PrazoEntrega DATETIME, DataPedido DATETIME)RETURNS varchar(30) DETERMINISTIC
BEGIN 
IF (PrazoEntrega - DataPedido) <3 THEN RETURN 'SEDEX';
ELSEIF (PrazoEntrega - DataPedido) >= 3 AND (PrazoEntrega - DataPedido) <= 7 THEN RETURN 'NORMAL';
ELSE RETURN 'NÃO PRIORITÁRIA';
END IF;
END$$
DELIMITER ;
SELECT p.CodPedido, c.Nome, ex5(p.PrazoEntrega, p.DataPedido)  AS Entrega
FROM cliente c JOIN pedido p 
ON c.CodCliente = p.CodCliente;

-- ex6: Crie uma função que faça a comparação entre dois números inteiros. Caso os dois números sejam
-- iguais a saída deverá ser “x é igual a y”, no qual x é o primeiro parâmetro e y o segundo parâmetro.
-- Se x for maior, deverá ser exibido “x é maior que y”. Se x for menor, deverá ser exibido “x é menor
-- que y”.
DELIMITER $$
CREATE FUNCTION ex6 (x INT, y INT)RETURNS varchar(30) DETERMINISTIC
BEGIN 
IF x = y THEN RETURN 'X É IGUAL A Y';
ELSEIF x > y THEN RETURN 'X É MAIOR QUE Y';
ELSEIF x < y THEN RETURN 'X É MENOR QUE Y';
END IF;
END$$
DELIMITER ;
SELECT ex6(2,3);

-- ex7: Crie uma função que calcule a fórmula de bhaskara. Como parâmetro de entrada devem ser
-- recebidos 3 valores (a, b e c). Ao final a função deve retornar “Os resultados calculados são x e y”,
-- no qual x e y são os valores calculados.
-- ver
DELIMITER $$
CREATE FUNCTION ex7 (a INT, b INT, c INT)RETURNS VARCHAR(200) DETERMINISTIC
BEGIN 

DECLARE resultado varchar(100);
DECLARE n DOUBLE;
-- SET n = (-(b) + SQRT((b * b) + (-4 * (a * c))));
SELECT CONCAT("Os resultados calculados são ", 
((-(b) + SQRT((b * b) + (-4 * (a * c)))) / (2 * a)) ," e ", 
((-(b) - SQRT((b * b) + (-4 * (a * c)))) / (2 * a))) INTO resultado;
RETURN(resultado);

END$$
DELIMITER ;
DROP FUNCTION ex7;

SELECT ex7(2,8,2) AS Bhaskara;

-- ex8: Crie uma função que retorne o valor total do salário de um vendedor (salário fixo + comissão
-- calculada). Note que esta função deve receber 3 valores de entrada, salário fixo, faixa de comissão
-- e o valor total vendido. Para testar essa função crie uma consulta que exiba o nome do vendedor e
-- o salário total.
DELIMITER $$
CREATE FUNCTION ex8 (SalarioFixo DECIMAL(10,2), FaixaComissao ENUM('A','B','C','D'), TotalVendido INT)
RETURNS INT DETERMINISTIC
BEGIN 
IF FaixaComissao = 'A' THEN RETURN ROUND(SalarioFixo+(TotalVendido*1.2),2);
ELSEIF FaixaComissao = 'B' THEN RETURN ROUND(SalarioFixo+(TotalVendido*1.15),2);
ELSEIF FaixaComissao = 'C' THEN RETURN ROUND(SalarioFixo+(TotalVendido*1.1),2);
ELSEIF FaixaComissao = 'D' THEN RETURN ROUND(SalarioFixo+(TotalVendido*1.05),2);
END IF;
END$$
DELIMITER ;

SELECT v.Nome, ex8(v.SalarioFixo, v.FaixaComissao, SUM(ip.Quantidade*p.ValorUnitario)) AS Salario 
FROM vendedor v LEFT JOIN pedido pe ON pe.CodVendedor=v.CodVendedor
LEFT JOIN itempedido ip ON ip.CodPedido = pe.CodPedido 
LEFT JOIN produto p ON p.CodProduto = ip.CodProduto 
GROUP BY v.CodVendedor;

-- ex9: DESAFIO 1: Crie uma função que receba um número IPv4 (Internet Protocol version 4) no formato
-- xxx.xxx.xxx.xxx e retorne a classe do mesmo e se é um IP válido ou inválido.

-- ex10: DESAFIO 2: Crie uma função que receba um número de CPF sem separadores xxxxxxxxxxx (11
-- dígitos) e verifique se o número é um CPF válido ou não. Caso seja um CPF válido retorne o
-- mesmo formatado corretamente xxx.xxx.xxx-xx, caso não seja válido, retorne a frase “O CPF
-- digitado é inválido”

-- LISTA 2 ----------------------------------------------------------------------------------------------------------------
-- ex1: Crie uma função para calcular um aumento de 10% no salário dos vendedores de faixa de comissão
-- 'A’. Considere o valor do salário fixo para calcular este aumento. Faça uma consulta select
-- utilizando essa função. perguntar
DELIMITER $$
CREATE FUNCTION ex12 (SalarioFixo DECIMAL(10,2))RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN 
RETURN (SalarioFixo*1.1);
END$$
DELIMITER ;
SELECT v.Nome, v.SalarioFixo, ex12(v.SalarioFixo)  AS Salário
FROM vendedor v WHERE v.FaixaComissao = 'A';
DROP FUNCTION ex12;

-- ex2: Crie uma função que retorne o código do produto com maior valor unitário.
DELIMITER $$
CREATE FUNCTION ex22 ()RETURNS INT DETERMINISTIC
BEGIN 
DECLARE produto INT;
SELECT pr.CodProduto FROM produto pr ORDER BY ValorUnitario DESC LIMIT 1 INTO produto;
RETURN produto;
END$$
DELIMITER ;
SELECT ex22() AS MaiorValorUnitario;

-- ex3: Crie uma função que retorne o código, a descrição e o valor do produto com maior valor unitário. Os
-- valores devem ser retornados em uma expressão: “O produto com código XXX – XXXXXXXXX
-- (descrição) possui o maior valor unitário R$XXXX,XX”. Crie um select que utiliza esta função
DELIMITER $$
CREATE FUNCTION ex32()
RETURNS VARCHAR(200) DETERMINISTIC
BEGIN 
DECLARE cod INT;
DECLARE descricao VARCHAR(200);
DECLARE valor DOUBLE;
SELECT pr.CodProduto FROM produto pr ORDER BY pr.ValorUnitario DESC LIMIT 1 INTO cod;
SELECT pr.Descricao FROM produto pr ORDER BY pr.ValorUnitario DESC LIMIT 1 INTO descricao;
SELECT pr.ValorUnitario FROM produto pr ORDER BY pr.ValorUnitario DESC LIMIT 1 INTO valor;
RETURN CONCAT("O produto com código ", cod," - ", descricao, " possui o maior valor unitário: R$",valor);
END$$
DELIMITER ;
DROP FUNCTION ex32;
SELECT ex32()  AS Produto;

-- ex4: Crie uma função que receba como parâmetros o código do produto com maior valor unitário e o
-- código do produto com menor valor unitário. Retorne a soma dos dois.
DELIMITER $$
CREATE FUNCTION ex42 (CodProdutoMax INT, CodProdutoMin INT)RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN 
DECLARE soma DECIMAL(10,2);
SELECT SUM(ValorUnitario) FROM produto WHERE CodProduto = CodProdutoMin OR CodProduto = CodProdutoMax INTO soma;
RETURN (soma);
END$$
DELIMITER ;

SELECT ex42((SELECT CodProduto FROM produto ORDER BY ValorUnitario ASC LIMIT 1), 
(SELECT CodProduto FROM produto ORDER BY ValorUnitario DESC LIMIT 1)) AS Soma;

-- ex5: Crie uma função que retorne a média do valor unitário dos produtos. Crie uma consulta que utilize
-- esta função.
DELIMITER $$
CREATE FUNCTION ex52() RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN 
RETURN (SELECT SUM(pr.ValorUnitario)/COUNT(pr.CodProduto) FROM produto pr);
END$$
DELIMITER ;
DROP FUNCTION ex52;
SELECT ex52() AS Média;

-- ex6: Faça uma função que retorna o código do cliente com a maior quantidade de pedidos um ano/mês.
-- Observe que a função deverá receber como parâmetros um ano e um mês. Deve ser exibido a
-- seguinte expressão: “O cliente XXXXXXX (cód) – XXXXXXX (nome) foi o cliente que fez a maior
-- quantidade de pedidos no ano XXXX mês XX com um total de XXX pedidos”.
DELIMITER $$
CREATE FUNCTION ex62(Ano INT, Mes INT)RETURNS VARCHAR(200) DETERMINISTIC
BEGIN 
DECLARE cod INT;
DECLARE nome VARCHAR(100);
DECLARE conta INT;

SELECT c.CodCliente, c.Nome, COUNT(p.CodPedido) INTO cod, nome, conta
FROM pedido p RIGHT JOIN cliente c ON p.CodCliente = c.CodCliente 
WHERE YEAR(p.DataPedido) = Ano AND MONTH(p.DataPedido) = Mes
GROUP BY c.CodCliente
ORDER BY COUNT(p.CodPedido) DESC LIMIT 1;

RETURN CONCAT("O cliente ", cod, " – ", nome, " foi o cliente que fez a maior
quantidade de pedidos no ano ", Ano, " mês ", Mes, " com um total de ", conta , " pedidos");
END$$
DELIMITER ;
DROP FUNCTION ex62;
SELECT ex62(2014,10) AS MelhorCliente;

-- ex7: Faça uma função que retorna a soma dos valores dos pedidos feitos por um determinado cliente.
-- Note que a função recebe por parâmetro o código de uma cliente e retorna o valor total dos pedidos
-- deste cliente. Faça a consulta utilizando Joins.
DELIMITER $$
CREATE FUNCTION ex72 (cod INT)RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN 
DECLARE valor DECIMAL(10,2);

SELECT SUM(pr.ValorUnitario*ip.Quantidade) INTO valor
FROM produto pr LEFT JOIN itempedido ip ON pr.CodProduto = ip.CodProduto
LEFT JOIN pedido pe ON ip.CodPedido = pe.CodPedido
LEFT JOIN cliente c ON pe.CodCliente = c.CodCliente
WHERE c.CodCliente = cod;

RETURN valor;
END$$
DELIMITER ;
DROP FUNCTION ex72;
SELECT ex72(111)  AS Valor;

-- ex8: Crie 3 funções. A primeira deve retornar a soma da quantidade de produtos de todos os pedidos. A
-- segunda, deve retornar o número total de pedidos e a terceira a média dos dois valores. Por fim,
-- crie uma quarta função que chama as outras três e exibe todos os resultados concatenados.
DELIMITER $$
CREATE FUNCTION soma()RETURNS INT DETERMINISTIC
BEGIN 
RETURN (SELECT SUM(ip.Quantidade) FROM itempedido ip);
END$$

CREATE FUNCTION quant()RETURNS INT DETERMINISTIC
BEGIN 
RETURN (SELECT COUNT(pe.CodPedido) FROM pedido pe);
END$$
DROP FUNCTION quant$$

CREATE FUNCTION media()RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN 
RETURN ((SELECT soma())/(SELECT quant()));
END$$
DROP FUNCTION media$$

CREATE FUNCTION ex8_2()RETURNS VARCHAR(200) DETERMINISTIC
BEGIN 
RETURN CONCAT("Soma: ", (SELECT soma()), " Quantidade: ", (SELECT quant()), " Média: ", (SELECT media()));
END$$
DELIMITER ;
DROP FUNCTION ex8_2;
SELECT ex8_2() AS Ex8;

-- ex9: Crie uma função que retorna o código do vendedor com maior número de pedidos para um
-- determinado ano/mês. Observe que a função deverá receber como parâmetros um ano e um mês.
-- Deve ser exibido a seguinte expressão: “O vendedor XXXXXXX (cód) – XXXXXXX (nome) foi o
-- vendedor que efetuou a maior quantidade de vendas no ano XXXX mês XX com um total de XXX
-- pedidos”.
DELIMITER $$
CREATE FUNCTION ex92 (Ano INT, Mes INT)RETURNS VARCHAR(200) DETERMINISTIC
BEGIN 
DECLARE cod INT;
DECLARE nome VARCHAR(100);
DECLARE conta INT;

SELECT v.CodVendedor, v.Nome, COUNT(p.CodPedido) INTO cod, nome, conta
FROM pedido p LEFT JOIN vendedor v ON p.CodVendedor = v.CodVendedor 
WHERE YEAR(p.DataPedido) = Ano AND MONTH(p.DataPedido) = Mes
GROUP BY v.CodVendedor
ORDER BY COUNT(p.CodPedido) DESC LIMIT 1;

RETURN CONCAT("O vendedor ", cod, " – ", nome, " foi o vendedor que efetuou a maior
quantidade de vendas no ano ", Ano, " mês ", Mes, " com um total de ", conta , " pedidos");
END$$
DELIMITER ;
DROP FUNCTION ex92;
SELECT ex92(2014,10) AS MelhorVendedor;

-- ex10: Crie uma função que retorne o nome e o endereço completo do cliente que fez o último
-- pedido na loja. (Pedido com a data mais recente).
DELIMITER $$
CREATE FUNCTION ex102()RETURNS VARCHAR(500) DETERMINISTIC
BEGIN 
DECLARE nome VARCHAR(100);
DECLARE endereco VARCHAR(255);
DECLARE cidade VARCHAR(60);
DECLARE cep VARCHAR(11);
DECLARE uf CHAR(2);

SELECT c.Nome, c.Endereco, c.Cidade, c.Cep, c.Uf INTO nome, endereco, cidade, cep, uf
FROM cliente c JOIN pedido pe ON pe.CodCliente = c.CodCliente
ORDER BY pe.DataPedido DESC LIMIT 1;
RETURN CONCAT("Nome: ", nome, " Endereço: ", endereco, " Cidade: ", cidade, " CEP: ", cep, " UF: ", uf);
        
END$$
DELIMITER ;
DROP FUNCTION ex102;
SELECT ex102() AS ÚltimoCliente;

-- ex11: Crie uma função que retorne a quantidade de pedidos realizados para clientes do Estado informado
-- (receber o estado como parâmetro).
DELIMITER $$
CREATE FUNCTION ex112 (estado CHAR(2))RETURNS INT DETERMINISTIC
BEGIN 

RETURN (SELECT COUNT(pe.CodPedido) 
		FROM pedido pe LEFT JOIN cliente c ON c.CodCliente = pe.CodCliente
        WHERE c.Uf = estado);

END$$
DELIMITER ;
SELECT ex112("RS") AS TotalPedidos;

-- ex12: Crie uma função que retorne o valor total que é gasto com os salários dos vendedores de certa faixa
-- de comissão. (Receber a faixa de comissão por parâmetro). Note que deve ser considerado o valor
-- total dos salários, incluindo a comissão. ver
DELIMITER $$
CREATE FUNCTION ex122 (faixa CHAR(1))RETURNS DOUBLE DETERMINISTIC
BEGIN 
DECLARE valor DOUBLE;
DECLARE total DOUBLE;

SELECT (SUM(ip.Quantidade*p.ValorUnitario)) INTO valor
FROM vendedor v LEFT JOIN pedido pe ON pe.CodVendedor=v.CodVendedor
LEFT JOIN itempedido ip ON ip.CodPedido = pe.CodPedido 
LEFT JOIN produto p ON p.CodProduto = ip.CodProduto
WHERE v.FaixaComissao = faixa;

CASE faixa
WHEN 'A' THEN (SELECT SUM(v.SalarioFixo+(valor*1.2)) FROM vendedor v) INTO total;
WHEN 'B' THEN (SELECT SUM(v.SalarioFixo+(valor*1.15)) FROM vendedor v) INTO total;
WHEN 'C' THEN (SELECT SUM(v.SalarioFixo+(valor*1.1)) FROM vendedor v) INTO total;
WHEN 'D' THEN (SELECT SUM(v.SalarioFixo+(valor*1.05)) FROM vendedor v) INTO total;
END CASE;

RETURN total;
END$$
DELIMITER ;
DROP FUNCTION ex122;
SELECT ex122('B') AS Total;

-- ex13: Crie uma função que mostre o cliente que fez o pedido mais caro da loja. O retorno da função
-- deverá ser: “O cliente XXXXXX efetuou o pedido XXXX (cód) em XXXX (data), o qual é o mais caro
-- registrado até o momento no valor total de R$XXXX,XX”.
DELIMITER $$
CREATE FUNCTION ex132 ()RETURNS VARCHAR(200) DETERMINISTIC
BEGIN 
DECLARE nome, datap VARCHAR(200);
DECLARE cod INT;
DECLARE valor DECIMAL(15,2);

SELECT c.nome, p.codpedido, p.datapedido, SUM(pr.valorunitario*ip.Quantidade) AS valor 
INTO nome, cod, datap, valor 
FROM cliente c JOIN pedido p ON p.codcliente = c.codcliente 
JOIN itempedido ip ON ip.codpedido=p.codpedido
JOIN produto pr ON pr.codproduto = ip.codproduto 
GROUP BY p.codpedido 
ORDER BY valor DESC LIMIT 1;

RETURN CONCAT("O cliente ", nome, " efetuou o pedido ", cod, " em ", datap, ", o qual é o mais caro
registrado até o momento no valor total de R$",valor); 

END$$
DELIMITER ;
DROP FUNCTION ex132;
SELECT ex132() AS MaiorPedido;

-- ex14: Crie uma função que mostre o valor total arrecadado com apenas um determinado produto em toda
-- a história da loja. Esta função deverá receber como parâmetro o código do produto e retornar a
-- seguinte expressão: “O valor total arrecadado com o produto XXXXXX (descrição) foi de R$XXXX,XX”.
DELIMITER $$
CREATE FUNCTION ex142 (cod INT)RETURNS VARCHAR(200) DETERMINISTIC
BEGIN 

DECLARE total DECIMAL(20,2);
DECLARE descricao VARCHAR(100);

SELECT SUM(ip.Quantidade*pr.ValorUnitario), pr.Descricao INTO total, descricao
FROM itempedido ip LEFT JOIN produto pr ON ip.CodProduto = pr.CodProduto
WHERE pr.CodProduto = cod
GROUP BY pr.CodProduto;

RETURN CONCAT("O valor total arrecadado com o produto ", descricao, " foi de R$", total);
END$$
DELIMITER ;
DROP FUNCTION ex142;
SELECT ex142(50) AS Total;

-- ex15: Crie uma função que mostre a quantidade total vendida para um determinado produto. A função
-- deverá receber como parâmetro o código do produto e retornar a quantidade total de itens que
-- foram vendidos para este produto.
DELIMITER $$
CREATE FUNCTION ex152 (cod INT)RETURNS VARCHAR(200) DETERMINISTIC
BEGIN 
DECLARE total INT;
DECLARE descricao VARCHAR(100);

SELECT COUNT(pr.CodProduto), pr.Descricao INTO total, descricao
FROM itempedido ip JOIN produto pr ON ip.CodProduto = pr.CodProduto
WHERE pr.CodProduto = cod
GROUP BY pr.CodProduto;

RETURN CONCAT("A quantidade vendida com o produto ", descricao, " foi de ", total );
END$$
DELIMITER ;
DROP FUNCTION ex152;
SELECT ex152(1) AS total;