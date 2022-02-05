defmodule ElixirJpCalendarWeb.PageController do
  use ElixirJpCalendarWeb, :controller

  alias ElixirJpCalendar.EventServer

  def index(conn, _params) do
    communities = EventServer.list_communities()

    render(conn, "index.html", communities: communities)
  end
end
