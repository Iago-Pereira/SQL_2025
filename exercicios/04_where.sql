-- Lista de clientes com 100 a 200 pontos(incluso)

SELECT idCliente,
       qtdePontos

FROM clientes

WHERE qtdePontos >= 100
      AND qtdePontos <= 200