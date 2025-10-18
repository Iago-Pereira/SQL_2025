-- CTE: COMMON TABLE EXPRESSION

-- SELECT count(DISTINCT IdCliente) AS Total
-- 
-- FROM transacoes AS t1
-- 
-- WHERE t1.IdCliente IN(
--     SELECT DISTINCT IdCliente
--     FROM transacoes
--     WHERE substr(DtCriacao, 1, 10) = '2025-08-25'
-- )
-- 
-- AND substr(t1.DtCriacao, 1, 10) = '2025-08-29'

WITH tb_clientes_primeiro_dia AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE substr(dtCriacao, 1, 10) = '2025-08-25'
),

tb_clientes_ultimo_dia AS (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE substr(dtCriacao, 1, 10) = '2025-08-29'
),

tb_join AS (
    SELECT t1.IdCliente AS primCliente,
           t2.IdCliente AS ultCliente
    FROM tb_clientes_primeiro_dia AS t1

    LEFT JOIN tb_clientes_ultimo_dia AS t2
    ON t1.IdCliente = t2.IdCliente
)

SELECT count(primCliente),
       count(ultCliente),
       1.0 * count(ultCliente) / count(primCliente) AS proporcao
FROM tb_join