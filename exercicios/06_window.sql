-- Quantidade de usuários cadastrados(absoluto e acumulado) ao longo do tempo

WITH tb_clientes_diarios AS (
    SELECT substr(DtCriacao, 1, 10) AS dtDia,
           count(DISTINCT IdCliente) AS qtdeClientes

    FROM clientes

    GROUP BY dtDia
),

tb_acum AS (
SELECT *,
       sum(qtdeClientes) OVER (ORDER BY dtDia) AS qtdeClientesAcum

FROM tb_clientes_diarios
)

-- Quando atingiu 3 mil clientes?

SELECT dtDia,
       qtdeClientesAcum

FROM tb_acum

WHERE qtdeClientesAcum >= 3000

ORDER BY qtdeClientesAcum

LIMIT 1