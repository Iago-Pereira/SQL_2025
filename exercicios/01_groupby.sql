-- Quantos clientes tem email cadastrado?

SELECT sum(flEmail) AS SomaEmail

FROM clientes;

SELECT count(*)

FROM clientes

WHERE flEmail = 1;