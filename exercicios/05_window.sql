-- Quantidade de transações acumuladas ao longo do tempo (diário)?

    WITH tb_diaria AS (
    SELECT substr(DtCriacao, 1, 10) AS dtDia,
           count(DISTINCT IdTransacao) AS qtdeTransacao

    FROM transacoes

    GROUP BY dtDia
),

tb_acum AS (
    SELECT *,
           sum(qtdeTransacao) OVER (ORDER BY dtDia) AS qtdeTransacaoAcum

    FROM tb_diaria
)

-- Quando atingiu 100 mil transações?

SELECT *

FROM tb_acum

WHERE qtdeTransacaoAcum >= 100000

ORDER BY qtdeTransacaoAcum

LIMIT 1