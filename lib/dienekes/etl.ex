defmodule Dienekes.ETL do
  @moduledoc """
  The ETL context.
  """

  import Ecto.Query, warn: false

  alias Dienekes.Repo
  alias Dienekes.Workers.{FetchManager, RetryPages}
  alias Dienekes.ETL.Numbers

  @max_concurrency System.schedulers_online() * 3
  @max_demand @max_concurrency * 4

  defp dienekes_api() do
    Application.get_env(:dienekes, :dienekes_api)
  end

  def start() do
    FetchManager.reset_state()
    RetryPages.pop_pages()

    fetch()
    |> sort_numbers()
    |> save_numbers()
  end

  defp fetch(numbers \\ [], batch \\ 1) do
    case FetchManager.state() do
      :stop_fetching ->
        pages_to_retry = RetryPages.pop_pages()

        if length(pages_to_retry) > 0 do
          retry(pages_to_retry) ++ numbers
        else
          numbers
        end

      :keep_fetching ->
        1..@max_demand
        |> Task.async_stream(
          fn page -> dienekes_api().fetch_numbers(page + (batch - 1) * @max_demand) end,
          ordered: false,
          timeout: :timer.seconds(20),
          max_concurrency: @max_concurrency
        )
        |> Enum.reduce([], &handle_page_response/2)
        |> Kernel.++(numbers)
        |> fetch(batch + 1)
    end
  end

  defp retry(pages) do
    pages
    |> Task.async_stream(
      fn page -> dienekes_api().fetch_numbers(page) end,
      ordered: false,
      timeout: :timer.seconds(20),
      max_concurrency: @max_concurrency
    )
    |> Enum.reduce([], &handle_page_response/2)
    |> fetch()
  end

  defp handle_page_response({:ok, {_page, []}}, acc) do
    FetchManager.stop()

    acc
  end

  defp handle_page_response({:ok, {page, nil}}, acc) do
    RetryPages.add_page_to_retry(page)

    acc
  end

  defp handle_page_response({:ok, {_page, numbers}}, acc) when is_list(numbers) do
    numbers ++ acc
  end

  def sort_numbers(numbers) do
    quick_sort(numbers)
  end

  defp quick_sort([]), do: []

  defp quick_sort([pivot | tail]) do
    {lower, higher} = Enum.split_with(tail, fn n -> n <= pivot end)

    quick_sort(lower) ++ [pivot] ++ quick_sort(higher)
  end

  def save_numbers(numbers) do
    %Numbers{}
    |> Numbers.changeset(%{numbers: numbers})
    |> Repo.insert()
  end

  def get_numbers() do
    Repo.one(from n in Numbers, order_by: [desc: n.id], limit: 1)
  end
end
