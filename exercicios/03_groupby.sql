-- Qual cliente fez mais transações no ano de 2024?

SELECT IdCliente,
       count(IdTransacao) AS QtdeTransacao

FROM transacoes

--WHERE substr(DtCriacao, 1, 4) = '2024'
WHERE DtCriacao >= '2024-01-01'
AND DtCriacao < '2025-01-01'

GROUP BY IdCliente

ORDER BY QtdeTransacao DESC

LIMIT 1