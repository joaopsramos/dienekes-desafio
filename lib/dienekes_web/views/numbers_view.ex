defmodule DienekesWeb.NumbersView do
  use DienekesWeb, :view

  def render("show.json", %{numbers: numbers}) do
    render_one(numbers, __MODULE__, "numbers.json")
  end

  def render("numbers.json", %{numbers: numbers}) do
    %{numbers: numbers}
  end
end
