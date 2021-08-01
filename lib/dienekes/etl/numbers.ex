defmodule Dienekes.ETL.Numbers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "numbers" do
    field :numbers, {:array, :float}

    timestamps()
  end

  def changeset(numbers, attrs) do
    numbers
    |> cast(attrs, [:numbers])
    |> validate_required([:numbers])
  end
end
