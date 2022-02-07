defmodule ElixirJpCalendar.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, args) do
    children =
      [
        # Start the Telemetry supervisor
        ElixirJpCalendarWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: ElixirJpCalendar.PubSub}
      ] ++ event_server_with_mock(args)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirJpCalendar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirJpCalendarWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def event_server_with_mock(env: :test) do
    [
      {Plug.Cowboy, scheme: :http, plug: ElixirJpCalendar.MockServer, options: [port: 8081]},
      ElixirJpCalendar.EventServer,
      ElixirJpCalendarWeb.Endpoint
    ]
  end

  def event_server_with_mock(_) do
    [ElixirJpCalendar.EventServer, ElixirJpCalendarWeb.Endpoint]
  end
end
