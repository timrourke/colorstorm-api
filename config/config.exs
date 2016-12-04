# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :colorstorm, Colorstorm.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "f39RVYckkdl/jKJTed7qC2OISf7j4H0fBXbfzGQdEUDT/M3b0N6sxAO+G5fcxMKk",
  render_errors: [Colorstorm.ErrorView, accepts: ~w(json json-api)],
  pubsub: [name: Colorstorm.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :colorstorm, ecto_repos: [Colorstorm.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures JSONAPI encoder
config :phoenix, :format_encoders,
  "json-api": Poison

# Configures JSONAPI mimetype
config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

# Configures Guardian's JWT claims
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Colorstorm",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: System.get_env("COLORSTORM_GUARDIAN_SECRET") || "uEk74kX3JIgmt/Oh+Xg+2CO5kLFGJbBajx337cXAopILnhkWPY6A3j3NaQa0+w5j",
  serializer: Colorstorm.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
