# %%
import pandas as pd
import sqlalchemy

# conexão com o banco
engine = sqlalchemy.create_engine("sqlite:///../data/database.db")

# lendo query do arquivo de texto
with open("etl_projeto.sql") as open_file:
    query = open_file.read()

print(query)
# %%

dates = [
    '2025-01-01',
    '2025-02-01',
    '2025-03-01',
    '2025-04-01',
    '2025-05-01',
]

for i in dates:
    # executa a query e traz os dados para o python
    df = pd.read_sql(query.format(date = i), engine)
    # pega os dados do Python e manda para o banco na tabela feature_store_cliente
    df.to_sql("feature_store_cliente", engine, index=False, if_exists="append")
# %%
