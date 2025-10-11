-- Lista de produtos que são "chapéu"

SELECT IdProduto,
       DescNomeProduto

FROM produtos

WHERE DescNomeProduto LIKE '%chapéu%'