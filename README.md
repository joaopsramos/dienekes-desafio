# Dienekes

  * Instale as dependências `mix deps.get`
  * Crie o banco e execute as migrations com  `mix ecto.setup`, talvez seja necessário mudar as credenciais do banco nos arquivos de configuração
  * Inicie o servidor com o iex `iex -S mix phx.server`
  * Execute os testes com `mix test`

## Buscando os números

Com o servidor iniciado junto com o iex, execute no terminal

```elixir
Dienekes.ETL.start()
```

## Visualizando os números buscados

Acesse http://localhost:4000/api/numbers?page=1
