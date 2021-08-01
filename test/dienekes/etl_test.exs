defmodule Dienekes.ETLTest do
  use Dienekes.DataCase, async: true

  alias Dienekes.ETL

  describe "numbers" do
    alias Dienekes.ETL.Numbers
    alias Dienekes.DienekesClient.InMemory.SimulateError

    def numbers_fixture() do
      {:ok, numbers} = ETL.save_numbers(Enum.map(1..100, & &1))

      numbers
    end

    test "start/0 fetch for numbers, sort and save them" do
      SimulateError.start_link()

      {:ok, _} = ETL.start()

      %Numbers{numbers: numbers} = ETL.get_numbers()

      expected_numbers =
        1..10
        |> Enum.map(fn _n -> Enum.shuffle(1..100) end)
        |> List.flatten()
        |> Enum.sort()

      assert numbers == expected_numbers
    end

    test "get_numbers/1 returns the latest inserted numbers" do
      numbers = numbers_fixture()
      assert ETL.get_numbers() == numbers
    end

    test "sort_numbers/1 sort list of numbers" do
      shuffled_list = Enum.shuffle(1..1_000)

      assert ETL.sort_numbers([]) == []
      assert Enum.sort(shuffled_list) == ETL.sort_numbers(shuffled_list)
    end
  end
end
