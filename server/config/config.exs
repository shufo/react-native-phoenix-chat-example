# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :server,
  ecto_repos: [Server.Repo]

# Configures the endpoint
config :server, Server.Endpoint,
  url: [host: "127.0.0.1"],
  http: [ip: {0, 0, 0, 0}, port: 4000],
  secret_key_base: "opuH7nrmm41ONQSYHnG1wKKel54zjEKD3ZkGUQ1zj0L6VY167fnSF4o1nzZLMtAt",
  render_errors: [view: Server.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Server.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
