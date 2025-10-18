-- Quais clientes mais perderam pontos por Lover?

SELECT t1.IdCliente,
       -- t1.IdTransacao,
       -- t1.QtdePontos,
       -- t2.IdProduto,
       -- t3.DescNomeProduto,
       -- t3.DescCategoriaProduto
       sum(t1.QtdePontos) AS totalPontos

FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto

WHERE t3.DescCategoriaProduto = 'lovers'

GROUP BY t1.IdCliente

ORDER BY 2

LIMIT 5