DROP TABLE IF EXISTS relatorio_diario;

CREATE TABLE IF NOT EXISTS relatorio_diario AS

WITH tb_diaria AS (
    SELECT substr(DtCriacao, 1, 10) AS dtDia,
           count(DISTINCT IdTransacao) AS qtdeTransacao

FROM transacoes

GROUP BY dtDia

ORDER BY dtDia
),

tb_acum AS (
    SELECT *,
           sum(qtdeTransacao) OVER (ORDER BY dtDia) AS qtdeTransacaoAcum

    FROM tb_diaria
)

SELECT *

FROM tb_acum;

SELECT *

FROM relatorio_diario;