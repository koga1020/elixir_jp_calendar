defmodule ElixirJpCalendarWeb.Event.IndexParams do
  @default_source "community"
  use Params.Schema, %{
    source: [field: :string, default: @default_source]
  }

  import Ecto.Changeset

  def changeset(ch, params) do
    ch
    |> cast(params, [:source])
    |> ignore_invalid_source()
  end

  def ignore_invalid_source(%Ecto.Changeset{changes: %{source: source}} = ch) do
    case source in ~w(event keyword) do
      true ->
        ch

      false ->
        change(ch, source: @default_source)
    end
  end

  def ignore_invalid_source(ch), do: ch
end
