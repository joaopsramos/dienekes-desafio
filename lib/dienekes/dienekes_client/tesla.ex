defmodule Dienekes.DienekesClient.Tesla do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://challenge.dienekes.com.br"
  plug Tesla.Middleware.JSON

  def fetch_numbers(page) when is_number(page) do
    IO.puts("page: #{page}")

    {:ok, response} = get("/api/numbers", query: [page: page])

    {page, response.body["numbers"]}
  end
end
