defmodule Dienekes.Repo.Migrations.CreateNumbers do
  use Ecto.Migration

  def change do
    create table(:numbers) do
      add :numbers, {:array, :float}

      timestamps()
    end
  end
end
