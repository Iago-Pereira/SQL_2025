SELECT IdProduto,
       DescNomeProduto,
       DescCategoriaProduto

FROM produtos

WHERE DescCategoriaProduto = 'rpg'

LIMIT 10