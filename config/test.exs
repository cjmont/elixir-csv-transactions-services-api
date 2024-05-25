import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :transactions_api, TransactionsApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "transactions_api_test",
  hostname: "db",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox


# We don't run a server during test. If one is required,
# you can enable the server option below.
config :transactions_api, TransactionsApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "B6wy5Xw5GuuTfBKN9pOeIubGAWnn71UofE5P/eCJDecNogTazBFh6VyW9uPNYlpR",
  server: false

# In test we don't send emails.
config :transactions_api, TransactionsApi.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true
