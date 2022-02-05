defmodule ElixirJpCalendarWeb.PageControllerTest do
  use ElixirJpCalendarWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Elixirイベントカレンダー"
  end
end
