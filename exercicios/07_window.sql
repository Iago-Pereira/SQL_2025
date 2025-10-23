-- Qual o dia da semana mais ativo de cada usuário?

WITH tb_cliente_semana AS (
    SELECT IdCliente,
           strftime('%w', substr(DtCriacao, 1, 10)) AS dtDiaSemana,
           count(DISTINCT IdTransacao) AS qtdeTransacao

    FROM transacoes

    GROUP BY IdCliente, dtDiaSemana
),

tb_rn AS (
    SELECT *,
           CASE
               WHEN dtDiaSemana = '1' THEN 'Segunda-Feira'
               WHEN dtDiaSemana = '2' THEN 'Terça-Feira'
               WHEN dtDiaSemana = '3' THEN 'Quarta-Feira'
               WHEN dtDiaSemana = '4' THEN 'Quinta-Feira'
               WHEN dtDiaSemana = '5' THEN 'Sexta-Feira'
               WHEN dtDiaSemana = '6' THEN 'Sabado'
               ELSE 'Domingo'
               END AS descDiaSemana,
           ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtdeTransacao DESC) AS rn

    FROM tb_cliente_semana
)

SELECT *

FROM tb_rn

WHERE rn = 1