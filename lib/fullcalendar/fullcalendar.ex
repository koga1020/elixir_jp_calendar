defmodule FullCalender do
  def to_event_model(events) when is_list(events) do
    Enum.map(events, &to_event_model/1)
  end

  def to_event_model(event) do
    %{
      title: event["title"],
      url: event["event_url"],
      start: event["started_at"],
      end: event["ended_at"]
    }
  end
end
