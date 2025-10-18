-- Quais clientes assinaram a lista de presença no dia 25/08/2025?

SELECT t1.IdCliente,
       t1.DtCriacao,
       t3.DescNomeProduto

FROM transacoes AS t1

LEFT JOIN transacao_produto AS t2
ON t1.IdTransacao = t2.IdTransacao

LEFT JOIN produtos AS t3
ON t2.IdProduto = t3.IdProduto

-- WHERE t1.DtCriacao LIKE '2025-08-25%'
WHERE substr(t1.DtCriacao, 1, 10) = '2025-08-25'
AND DescNomeProduto = 'Lista de presença'