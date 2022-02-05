defmodule ElixirJpCalendarWeb.EventController do
  use ElixirJpCalendarWeb, :controller

  alias ElixirJpCalendar.EventServer
  alias ElixirJpCalendarWeb.Event.IndexParams

  def index(conn, params) do
    index_params =
      params
      |> IndexParams.from(with: &IndexParams.changeset/2)
      |> Params.to_map()

    %{data: data} = EventServer.list_events()

    %{events: events} =
      Enum.find(data, fn %{source: source} -> source == String.to_atom(index_params.source) end)

    render(conn, "index.json", events: events)
  end
end
