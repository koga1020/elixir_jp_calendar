import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :elixir_jp_calendar, ElixirJpCalendarWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "owjkvv/a6L8mE/vEJdyaT4YeEswzZfmwDFJmX/yRnjpLuGBVgOrShmG8mKDa0n/0",
  server: false

# In test we don't send emails.
config :elixir_jp_calendar, ElixirJpCalendar.Mailer, adapter: Swoosh.Adapters.Test

config :elixir_jp_calendar, ElixirJpCalendar.EventServer, delay: 0

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :ex_connpass, api_base_url: "http://localhost:8081/"
