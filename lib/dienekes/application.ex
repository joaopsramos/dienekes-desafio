defmodule Dienekes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Dienekes.Repo,
      # Start the Telemetry supervisor
      DienekesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dienekes.PubSub},
      # Start the Endpoint (http/https)
      DienekesWeb.Endpoint,
      # Start a worker by calling: Dienekes.Worker.start_link(arg)
      # {Dienekes.Worker, arg}
      Dienekes.Workers.FetchManager,
      Dienekes.Workers.RetryPages
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dienekes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DienekesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
