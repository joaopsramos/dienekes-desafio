defmodule Dienekes.Workers.FetchManager do
  use Agent

  def start_link(_initial_value) do
    Agent.start_link(fn -> :keep_fetching end, name: __MODULE__)
  end

  def state do
    Agent.get(__MODULE__, & &1)
  end

  def reset_state do
    Agent.update(__MODULE__, fn _state -> :keep_fetching end)
  end

  def stop do
    Agent.update(__MODULE__, fn _state -> :stop_fetching end)
  end
end
