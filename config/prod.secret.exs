use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :colorstorm, Colorstorm.Endpoint,
  secret_key_base: System.get_env("COLORSTORM_SECRET_KEY_BASE")

# Configure your database
config :colorstorm, Colorstorm.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("COLORSTORM_PSQL_USERNAME"),
  password: System.get_env("COLORSTORM_PSQL_PASSWORD"),
  database: "colorstorm_prod",
  hostname: "localhost",
  #url: System.get_env("DATABASE_URL"),
  pool_size: 20

config :colorstorm, Colorstorm.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: SYSTEM.get_env("COLORSTORM_SMTP_HOST"),
  port: SYSTEM.get_env("COLORSTORM_SMTP_PORT"),
  username: SYSTEM.get_env("COLORSTORM_SMTP_USERNAME"),
  password: SYSTEM.get_env("COLORSTORM_SMTP_PASSWORD"),
  tls: :if_available, # can be `:always` or `:never`
  ssl: true, # can be `true`
  retries: 1
