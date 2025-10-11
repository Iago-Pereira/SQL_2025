-- Listar todas as transações adicionando uma coluna nova sinalizando:
-- Baixo  | < 10
-- Médio | < 500
-- Alto | >= 500

SELECT IdTransacao,
       QtdePontos,
       CASE
            WHEN QtdePontos < 10 THEN 'Baixo'
            WHEN QtdePontos < 500 THEN 'Médio'
            Else 'Alto'
       END AS NivelPontos

FROM transacoes

ORDER BY QtdePontos DESC