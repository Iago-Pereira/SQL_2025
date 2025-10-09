-- Selecione produtos que tem 'churn' no nome

SELECT *

FROM produtos

-- WHERE DescNomeProduto = 'Churn_10pp'
-- OR DescNomeProduto = 'Churn_2pp'
-- OR DescNomeProduto = 'Churn_5pp'

-- WHERE DescNomeProduto IN ('Churn_10pp', 'Churn_2pp', 'Churn_5pp')

-- WHERE DescNomeProduto LIKE '%churn%' [Muito custoso principalmente em grandos brancos]

-- Se o dado estiver bem organizado, sempre é melhor selecionar pela categoria:

WHERE DescCategoriaProduto = 'churn_model'