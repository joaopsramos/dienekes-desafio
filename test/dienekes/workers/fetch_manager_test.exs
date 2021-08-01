defmodule Dienekes.Workers.FetchManagerTest do
  use ExUnit.Case

  alias Dienekes.Workers.FetchManager

  test "reset_state/0 reset to :keep_fetching" do
    FetchManager.reset_state()
    assert FetchManager.state() == :keep_fetching
  end

  test "stop/0 update state to :stop_fetching" do
    FetchManager.stop()
    assert FetchManager.state() == :stop_fetching
  end
end
