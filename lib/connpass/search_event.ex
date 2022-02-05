defmodule Connpass.SearchEvent do
  import Commandex

  require Logger

  command do
    param :search_params

    data :api_url
    data :events
    data :response

    pipeline :build_url
    pipeline :call_api
    pipeline :decode
  end

  def build_url(command, %{search_params: params}, _data) do
    query_string = URI.encode_query(params)

    api_url =
      URI.to_string(%URI{
        scheme: "https",
        host: "connpass.com",
        path: "/api/v1/event/",
        query: query_string
      })

    put_data(command, :api_url, api_url)
  end

  def call_api(command, _params, %{api_url: api_url}) do
    Logger.info("call #{api_url}")

    api_url
    |> HTTPoison.get()
    |> then(fn
      {:error, error} ->
        put_error(command, :call_api, error) |> halt()

      {:ok, response} ->
        put_data(command, :response, response)
    end)
  end

  def decode(command, _params, %{response: %HTTPoison.Response{body: body}}) do
    %{"events" => events} = Jason.decode!(body)

    put_data(command, :events, events)
  end
end
