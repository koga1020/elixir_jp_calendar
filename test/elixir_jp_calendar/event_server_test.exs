defmodule ElixirJpCalendar.EventServerTest do
  use ElixirJpCalendarWeb.ConnCase

  test "list_events/0" do
    assert ElixirJpCalendar.EventServer.list_events() == %{
             data: [
               %{
                 events: [
                   %{
                     end: "2021-10-26T21:00:00+09:00",
                     start: "2021-10-26T19:30:00+09:00",
                     title: "sample event",
                     url: "http://localhost:8081/event/1"
                   }
                 ],
                 source: :community
               },
               %{
                 events: [
                   %{
                     end: "2021-10-26T21:00:00+09:00",
                     start: "2021-10-26T19:30:00+09:00",
                     title: "sample elixir",
                     url: "http://localhost:8081/event/1"
                   }
                 ],
                 source: :keyword
               }
             ]
           }
  end
end
