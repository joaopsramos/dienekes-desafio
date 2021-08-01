defmodule Dienekes.Repo do
  use Ecto.Repo,
    otp_app: :dienekes,
    adapter: Ecto.Adapters.Postgres
end
