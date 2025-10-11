-- Qual o valor médio de pontos positivos por dia?

SELECT sum(QtdePontos) AS TotalPontos,
       -- count(substr(DtCriacao, 1, 10)) AS QtdeDiasRepetidos,
       -- Os dias se repetem, deste modo precisa realiza a contagem distinta
       count(DISTINCT substr(DtCriacao, 1, 10)) AS QtdeDiasUnicos,
       sum(QtdePontos) / count(DISTINCT substr(DtCriacao, 1, 10)) AS MediaPontosDiários

FROM transacoes

WHERE QtdePontos > 0

