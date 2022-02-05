defmodule ElixirJpCalendarWeb.EventView do
  use ElixirJpCalendarWeb, :view

  def render("index.json", %{events: events}) do
    events
  end
end
