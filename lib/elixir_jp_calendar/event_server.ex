defmodule ElixirJpCalendar.EventServer do
  use GenServer

  @communities [
    %{
      name: "fukuoka.ex／kokura.ex／EDI",
      series_id: 5294,
      url: "https://fukuokaex.connpass.com/"
    },
    %{
      name: "piyopiyo.ex",
      series_id: 11907,
      url: "https://piyopiyoex.connpass.com/"
    },
    %{
      name: "NervesJP",
      series_id: 8800,
      url: "https://nerves-jp.connpass.com/"
    },
    %{
      name: "LiveView JP",
      series_id: 12092,
      url: "https://liveviewjp.connpass.com/"
    },
    %{
      name: "autoracex",
      series_id: 11144,
      url: "https://autoracex.connpass.com/"
    },
    %{
      name: "beam-lang.tokyo",
      series_id: 1632,
      url: "https://beam-lang.connpass.com/"
    },
    %{
      name: "OkazaKirin.beam",
      series_id: 9575,
      url: "https://okazakirin-beam.connpass.com/"
    },
    %{
      name: "kochi.ex",
      series_id: 8111,
      url: "https://kochi-ex.connpass.com/"
    },
    %{
      name: "清流Elixir",
      series_id: 7578,
      url: "https://elixir-sr.connpass.com/"
    },
    %{
      name: "エリジョ ～Elixir女子部～",
      series_id: 9138,
      url: "https://elijo.connpass.com/"
    },
    %{
      name: "Sapporo.beam",
      series_id: 8525,
      url: "https://sapporo-beam.connpass.com/"
    },
    %{
      name: "space.ex",
      series_id: 10320,
      url: "https://spaceex.connpass.com/"
    },
    %{
      name: "Pelemay",
      series_id: 9485,
      url: "https://pelemay.connpass.com/"
    }
  ]

  def start_link(_) do
    GenServer.start_link(__MODULE__, refresh(), name: __MODULE__)
  end

  @impl true
  def init(state) do
    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_info(:work, _) do
    events = refresh()

    # Reschedule once more
    schedule_work()

    {:noreply, events}
  end

  @impl true
  def handle_call(:events, _, state) do
    {:reply, state, state}
  end

  defp schedule_work do
    Process.send_after(self(), :work, :timer.hours(1))
  end

  def list_events() do
    GenServer.call(__MODULE__, :events)
  end

  def refresh() do
    params_for_community_event = [count: 100, order: 3] ++ build_series_id_keywords()
    params_for_elixir_keyword_event = [keyword: "elixir", count: 100, order: 3]

    data =
      [
        {:community, params_for_community_event},
        {:keyword, params_for_elixir_keyword_event}
      ]
      |> Enum.map(fn {source, params} ->
        delay = Application.fetch_env!(:elixir_jp_calendar, ElixirJpCalendar.EventServer)[:delay]

        :timer.sleep(delay)

        %{
          source: source,
          events: fetch_events(params)
        }
      end)

    %{
      data: data
    }
  end

  def fetch_events(params) do
    ExConnpass.run(%{query: params})
    |> case do
      %{success: true, data: %{events: events}} ->
        FullCalender.to_event_model(events)

      _ ->
        []
    end
  end

  def list_communities() do
    Enum.sort_by(@communities, & &1.series_id)
  end

  def build_series_id_keywords() do
    @communities
    |> Enum.map(& &1.series_id)
    |> Enum.map(&{:series_id, &1})
  end
end
