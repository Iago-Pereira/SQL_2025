-- Quantidade de transações históricas (vida, últimos 7 dias, 14 dias, 28 dias e 56 dias)

WITH tb_transacoes AS (
    SELECT IdTransacao,
           IdCliente,
           QtdePontos,
           datetime(substr(DtCriacao, 1, 19)) AS DtCriacao,
           julianday('now') - julianday(substr(DtCriacao, 1, 10)) AS diffDate,
           CAST(strftime('%H', substr(DtCriacao, 1, 19)) AS INTEGER) AS dtHora

    FROM transacoes
),

-- Idade do cliente na base
tb_cliente AS (
    SELECT IdCliente,
           datetime(substr(DtCriacao, 1, 19)) AS DtCriacao,
           julianday('now') - julianday(substr(DtCriacao, 1, 10)) AS IdadeBase

    FROM clientes
),

tb_sumario_transacoes AS (
    SELECT IdCliente,
           count(IdTransacao) AS QtdetransacoesVida,
           count(CASE WHEN diffDate <= 56 THEN IdTransacao END) AS QtdeTransacao56,
           count(CASE WHEN diffDate <= 28 THEN IdTransacao END) AS QtdeTransacao28,
           count(CASE WHEN diffDate <= 14 THEN IdTransacao END) AS QtdeTransacao14,
           count(CASE WHEN diffDate <= 7 THEN IdTransacao END) AS QtdeTransacao7,
           -- Quantidade de dias desde a última transação
           min(diffDate) AS diasUltimaInteracao,
           -- Saldo de pontos atual
           sum(qtdePontos) AS saldoPontos,
           -- Pontos acumulados positivos(vida, d7, d14, d28, d56)
           sum(CASE WHEN qtdePontos > 0 THEN qtdePontos ELSE 0 END) AS QtdePontosPosVida,
           sum(CASE WHEN qtdePontos > 0 AND diffDate <= 56 THEN qtdePontos ELSE 0 END) AS QtdePontosPos56,
           sum(CASE WHEN qtdePontos > 0 AND diffDate <= 28 THEN qtdePontos ELSE 0 END) AS QtdePontosPos28,
           sum(CASE WHEN qtdePontos > 0 AND diffDate <= 14 THEN qtdePontos ELSE 0 END) AS QtdePontosPos14,
           sum(CASE WHEN qtdePontos > 0 AND diffDate <= 7 THEN qtdePontos ELSE 0 END) AS QtdePontosPos7,
           -- Pontos acumulados negativos(vida, d7, d14, d28, d56)
           sum(CASE WHEN qtdePontos < 0 THEN qtdePontos ELSE 0 END) AS QtdePontosNegVida,
           sum(CASE WHEN qtdePontos < 0 AND diffDate <= 56 THEN qtdePontos ELSE 0 END) AS QtdePontosNeg56,
           sum(CASE WHEN qtdePontos < 0 AND diffDate <= 28 THEN qtdePontos ELSE 0 END) AS QtdePontosNeg28,
           sum(CASE WHEN qtdePontos < 0 AND diffDate <= 14 THEN qtdePontos ELSE 0 END) AS QtdePontosNeg14,
           sum(CASE WHEN qtdePontos < 0 AND diffDate <= 7 THEN qtdePontos ELSE 0 END) AS QtdePontosNeg7

    FROM tb_transacoes
    GROUP BY IdCliente
),

-- Produto mais usado (vida, d7, d14, d28, d56)
tb_transacao_produto AS (
    SELECT t1.*,
           t3.DescNomeProduto,
           t3.DescCategoriaProduto

    FROM tb_transacoes AS t1

    LEFT JOIN transacao_produto AS t2
    ON t1.IdTransacao = t2.IdTransacao

    LEFT JOIN produtos AS t3
    ON t2.idProduto = t3.idProduto
),

tb_cliente_produto AS (
SELECT IdCliente,
       DescNomeProduto,
       count(*) AS qtdeVida,
       count(CASE WHEN diffDate <= 56 THEN idTransacao END) AS qtde56,
       count(CASE WHEN diffDate <= 28 THEN idTransacao END) AS qtde28,
       count(CASE WHEN diffDate <= 14 THEN idTransacao END) AS qtde14,
       count(CASE WHEN diffDate <= 7 THEN idTransacao END) AS qtde7

FROM tb_transacao_produto

GROUP BY idCliente, DescNomeProduto
),

tb_cliente_produto_rn AS (
SELECT *,
       row_number() OVER (PARTITION BY IdCliente ORDER BY qtdeVida DESC) AS rnVida,
       row_number() OVER (PARTITION BY IdCliente ORDER BY qtde56 DESC) AS rn56,
       row_number() OVER (PARTITION BY IdCliente ORDER BY qtde28 DESC) AS rn28,
       row_number() OVER (PARTITION BY IdCliente ORDER BY qtde14 DESC) AS rn14,
       row_number() OVER (PARTITION BY IdCliente ORDER BY qtde7 DESC) AS rn7

FROM tb_cliente_produto
),

-- Dias da semana mais ativos (D28)
tb_cliente_dia AS (
    SELECT IdCliente,
           strftime('%w', DtCriacao) AS dtDia,
           count(*) AS qtdeTransacao

    FROM tb_transacoes
    WHERE diffDate <= 28
    GROUP BY IdCliente, dtDia
),

tb_cliente_dia_rn AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtdeTransacao DESC) AS rnDia

    FROM tb_cliente_dia
),

-- Período do dia mais ativo (D28)
tb_cliente_periodo AS (
    SELECT IdCliente,
           dtHora,
           CASE 
               WHEN dtHora BETWEEN 5 AND 12 THEN 'MANHÃ'
               WHEN dtHora BETWEEN 13 AND 18 THEN 'TARDE'
               WHEN dtHora BETWEEN 19 AND 23 THEN 'NOITE'
               ELSE 'MADRUGADA'
           END AS periodo,
           COUNT(*) AS qtdeTransacao

    FROM tb_transacoes

    WHERE diffDate <= 28

    GROUP BY IdCliente, dtHora
),

tb_cliente_periodo_rn AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY qtdeTransacao DESC) AS rnPeriodo

    FROM tb_cliente_periodo
),

tb_join AS (
    SELECT t1.*,
           t2.IdadeBase,
           t3.DescNomeProduto AS produtoVida,
           t4.DescNomeProduto AS produto56,
           t5.DescNomeProduto AS produto28,
           t6.DescNomeProduto AS produto14,
           t7.DescNomeProduto AS produto7,
           COALESCE(t8.dtDia, -1) AS dtDia,
           COALESCE(t9.periodo, 'SEM INFORMACAO')  AS periodoMaisTransacoes28

    FROM tb_sumario_transacoes AS t1

    LEFT JOIN tb_cliente AS t2
    ON t1.IdCliente = t2.IdCliente

    LEFT JOIN tb_cliente_produto_rn AS t3
    ON t1.idCliente = t3.idCliente
    AND t3.rnVida = 1

    LEFT JOIN tb_cliente_produto_rn AS t4
    ON t1.idCliente = t4.idCliente
    AND t4.rn56 = 1

    LEFT JOIN tb_cliente_produto_rn AS t5
    ON t1.idCliente = t5.idCliente
    AND t4.rn28 = 1

    LEFT JOIN tb_cliente_produto_rn AS t6
    ON t1.idCliente = t6.idCliente
    AND t4.rn14 = 1

    LEFT JOIN tb_cliente_produto_rn AS t7
    ON t1.idCliente = t7.idCliente
    AND t4.rn7 = 1

    LEFT JOIN tb_cliente_dia_rn AS t8
    ON t1.idCliente = t8.idCliente
    AND t8.rnDia = 1

    LEFT JOIN tb_cliente_periodo_rn AS t9
    ON t1.idCliente = t9.idCliente
    AND t9.rnPeriodo = 1
)

SELECT *,
       -- Engajamento em D28 versus Vida
       1.0 * qtdeTransacao28 / qtdeTransacoesVida AS engajamento28Vida

FROM tb_join

WHERE engajamento28Vida > 0