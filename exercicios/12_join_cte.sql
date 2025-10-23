-- Dentre os clientes de janeiro/2025, quantos assistiram o curso de SQL?

WITH tb_clientes_jan AS (
    SELECT DISTINCT IdCliente

    FROM transacoes

    WHERE DtCriacao >= '2025-01-01'
    AND DtCriacao < '2025-02-01'
),

tb_clientes_sql AS (
    SELECT DISTINCT IdCliente

    FROM transacoes

    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'
)

-- Com INNER JOIN
-- SELECT count(DISTINCT t1.IdCliente) AS QtdeClientes,0
-- 
-- FROM tb_clientes_jan AS t1
-- 
-- INNER JOIN tb_clientes_sql AS t2
-- ON t1.IdCliente = t2.IdCliente

-- Com LEFT JOIN
SELECT count(t1.IdCliente) AS ClientesJan,
       count(t2.IdCliente) AS ClientesSQL

FROM tb_clientes_jan AS t1

LEFT JOIN tb_clientes_sql AS t2
ON t1.IdCliente = t2.IdCliente