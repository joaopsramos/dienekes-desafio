defmodule DienekesWeb.NumbersControllerTest do
  use DienekesWeb.ConnCase, async: true

  alias Dienekes.ETL

  def fixture(:numbers, quantity \\ 100) do
    {:ok, numbers} = ETL.save_numbers(Enum.map(1..quantity, & &1))
    numbers
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "list numbers", %{conn: conn} do
      conn = get(conn, Routes.numbers_path(conn, :index))
      assert json_response(conn, 200)["numbers"] == []

      fixture(:numbers)
      conn = get(conn, Routes.numbers_path(conn, :index))
      assert json_response(conn, 200)["numbers"] == Enum.map(1..100, & &1)
    end

    test "numbers pagination", %{conn: conn} do
      fixture(:numbers, 1000)

      conn = get(conn, Routes.numbers_path(conn, :index), page: 1)
      assert json_response(conn, 200)["numbers"] == Enum.map(1..500, & &1)

      conn = get(conn, Routes.numbers_path(conn, :index), page: 2)
      assert json_response(conn, 200)["numbers"] == Enum.map(501..1000, & &1)
    end
  end
end
