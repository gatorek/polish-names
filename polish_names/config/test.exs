import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :polish_names, PolishNames.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "8011",
  database: "polish_names_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :polish_names, PolishNamesWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "zsGVZOYYYnjvRPDWmhbzm4i34oXonVLiCW8eF2Sw5ey+XP/1e4O9T7dfCOkLtDoe",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :modular,
  area_mocking_enabled: true,
  areas: [
    # Here go the areas names
  ]
