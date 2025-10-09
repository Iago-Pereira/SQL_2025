-- Selecione todos os cliente com mais de 500 pontos

SELECT IdCliente,
       QtdePontos

FROM clientes

WHERE QtdePontos > 500