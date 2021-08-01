# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dienekes,
  ecto_repos: [Dienekes.Repo]

# Configures the endpoint
config :dienekes, DienekesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qPYpxW0iS5K1VEcIOclmp00GPh3+NEzOh32yM1jdCWiD671HKCwjE1OpPNWywkfX",
  render_errors: [view: DienekesWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Dienekes.PubSub,
  live_view: [signing_salt: "44WT3yux"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Custom configs

config :tesla, adapter: Tesla.Adapter.Hackney
config :dienekes, dienekes_api: Dienekes.DienekesClient.Tesla

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
