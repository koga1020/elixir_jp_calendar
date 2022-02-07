defmodule ElixirJpCalendar.MockServer do
  use Plug.Router

  plug Plug.Parsers,
    parsers: [:url_encoded]

  plug :match
  plug :dispatch

  @default_resp %{
    results_returned: 0,
    results_available: 0,
    results_start: 0,
    events: []
  }

  get "/" do
    resp =
      case conn.params do
        %{"keyword" => keyword} ->
          %{
            results_returned: 1,
            results_available: 100,
            results_start: 1,
            events: [
              %{
                title: "sample #{keyword}",
                event_id: 1,
                started_at: "2021-10-26T19:30:00+09:00",
                ended_at: "2021-10-26T21:00:00+09:00",
                event_url: "http://localhost:8081/event/1"
              }
            ]
          }

        %{"series_id" => series_id} ->
          %{
            results_returned: 1,
            results_available: 100,
            results_start: 1,
            events: [
              %{
                title: "sample event",
                event_id: 1,
                started_at: "2021-10-26T19:30:00+09:00",
                ended_at: "2021-10-26T21:00:00+09:00",
                event_url: "http://localhost:8081/event/1",
                series: %{
                  id: series_id,
                  title: "sample group"
                }
              }
            ]
          }

        _ ->
          @default_resp
      end

    conn
    |> Plug.Conn.send_resp(200, Jason.encode!(resp))
  end

  get "/not-found-route" do
    Plug.Conn.send_resp(conn, 404, "")
  end
end
