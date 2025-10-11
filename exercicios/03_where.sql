-- Lista de clientes com zero pontos

SELECT IdCliente,
       qtdePontos

FROM clientes

WHERE qtdePontos = 0