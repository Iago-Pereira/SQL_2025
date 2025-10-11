-- Qual o produto com mais pontos transacionados?

SELECT IdProduto,
       sum(vlProduto * QtdeProduto) AS TotalProduto

FROM transacao_produto

WHERE QtdeProduto > 0

GROUP BY IdProduto

ORDER BY 2 DESC