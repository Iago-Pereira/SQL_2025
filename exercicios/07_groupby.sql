-- Qual o produto mais transacionado?

SELECT IdProduto,
       count(DISTINCT IdTransacao) AS QtdeTransacoes

FROM transacao_produto

WHERE QtdeProduto > 0

GROUP BY IdProduto

ORDER BY 2 DESC

LIMIT 1