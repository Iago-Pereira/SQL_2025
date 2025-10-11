-- Qual dia da semana que tem mais transações em 2025?

SELECT
       strftime('%w', datetime(substr(DtCriacao, 1, 19))) AS DiaSemana,
       count(IdTransacao) QtdeTransacoes

FROM transacoes

-- WHERE DtCriacao >= '2025-01-01'
-- AND DtCriacao < '2026-01-01'

WHERE substr(DtCriacao, 1, 4) = '2025'

GROUP BY 1

ORDER BY 2 DESC