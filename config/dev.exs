use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :colorstorm, Colorstorm.Endpoint,
  http: [port: 4000],
  url: [host: "localhost"],
  #debug_errors: true,
  code_reloader: false,
  check_origin: false,
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :colorstorm, Colorstorm.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "colorstorm_dev",
  hostname: "localhost",
  pool_size: 10

import_config "dev.secret.exs"