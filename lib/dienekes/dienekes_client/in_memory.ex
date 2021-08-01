defmodule Dienekes.DienekesClient.InMemory do
  defmodule SimulateError do
    use Agent

    def start_link() do
      Agent.start_link(fn -> :first_request end, name: __MODULE__)
    end

    def value do
      Agent.get(__MODULE__, & &1)
    end

    def update(new_state) do
      Agent.update(__MODULE__, fn _old_state -> new_state end)
    end
  end

  def fetch_numbers(page) when page > 10 do
    {page, []}
  end

  def fetch_numbers(page) when is_number(page) do
    # Error simulation
    if page == 3 && SimulateError.value() == :first_request do
      SimulateError.update(:not_first_request)
      {page, nil}
    else
      {page, Enum.shuffle(1..100)}
    end
  end
end
