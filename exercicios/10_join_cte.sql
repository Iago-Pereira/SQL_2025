-- Como foi a curva de churn do curso de SQL?

-- SELECT
--        substr(DtCriacao, 1, 10) AS dtDia,
--        count(DISTINCT IdCliente) AS qtdeCliente
-- 
-- FROM transacoes
-- 
-- WHERE DtCriacao >= '2025-08-25'
-- AND DtCriacao < '2025-08-30'
-- 
-- GROUP BY dtDia

WITH tb_clientes_d1 AS (
    SELECT DISTINCT IdCliente

    FROM transacoes

    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-26'
)

SELECT
       substr(t2.DtCriacao, 1, 10) AS dtDia,
       count(DISTINCT t1.IdCliente) AS qtdeCliente,
       ROUND(1.0 * count(DISTINCT t1.IdCliente) / (SELECT count(*) FROM tb_clientes_d1), 2) AS propRetencao,
       ROUND(1 - 1.0 * count(DISTINCT t1.IdCliente) / (SELECT count(*) FROM tb_clientes_d1), 2) AS propChurn


FROM tb_clientes_d1 AS t1

LEFT JOIN transacoes AS t2
ON t1.IdCliente = t2.IdCliente

WHERE t2.DtCriacao >= '2025-08-25'
AND t2.DtCriacao < '2025-08-30'

GROUP BY dtDia