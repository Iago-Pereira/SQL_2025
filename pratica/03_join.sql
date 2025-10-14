-- Qual mês tivemos mais lista de presença assinada?

SELECT -- t1.IdTransacao,
       -- t1.DtCriacao, 
       -- t3.DescNomeProduto
       substr(t1.DtCriacao, 1, 7) AS AnoMes,
       count(DISTINCT t1.IdTransacao) AS TotalTransacao

FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto

WHERE DescNomeProduto = 'Lista de presença'

GROUP BY AnoMes

ORDER BY 2 DESC