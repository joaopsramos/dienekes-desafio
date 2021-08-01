defmodule Dienekes.Workers.RetryPages do
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def pop_pages do
    Agent.get_and_update(__MODULE__, fn pages -> {pages, []} end)
  end

  def add_page_to_retry(page) do
    Agent.update(__MODULE__, fn pages -> [page] ++ pages end)
  end
end
