defmodule DienekesWeb.NumbersController do
  use DienekesWeb, :controller

  alias Dienekes.ETL
  alias Dienekes.ETL.Numbers

  action_fallback DienekesWeb.FallbackController

  @per_page 500

  def index(conn, %{"page" => page}) do
    case Integer.parse(page) do
      :error ->
        render_error(conn, "page must be an number")

      {page, _} ->
        if page > 0 do
          render_numbers(conn, page)
        else
          render_error(conn, "page must be positive")
        end
    end
  end

  def index(conn, _params) do
    render_numbers(conn, 1)
  end

  def render_numbers(conn, page) do
    case ETL.get_numbers() do
      nil ->
        render(conn, "numbers.json", numbers: [])

      %Numbers{numbers: numbers} ->
        render(conn, "numbers.json",
          numbers:
            numbers
            |> Stream.chunk_every(@per_page)
            |> Enum.at(page - 1, [])
        )
    end
  end

  defp render_error(conn, message, status \\ 400) do
    conn
    |> json(%{error: message})
    |> put_status(status)
    |> halt()
  end
end
