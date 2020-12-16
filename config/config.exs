# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :compo,
  ecto_repos: [Compo.Repo]

# Configures the endpoint
config :compo, CompoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "G/hf2+axicxYZVAoVOIqfP2I0Bq45CkQHY8U0vsmKkNKv9APj6fqddgff4QLyL4D",
  render_errors: [view: CompoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Compo.PubSub,
  live_view: [signing_salt: "KxEWibOO"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
