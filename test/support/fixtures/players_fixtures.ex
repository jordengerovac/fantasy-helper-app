defmodule FantasyHelperApp.PlayersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FantasyHelperApp.Players` context.
  """

  @doc """
  Generate a player.
  """
  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        games_played: 42,
        name: "some name",
        position: "some position",
        team: "some team",
        type: "some type"
      })
      |> FantasyHelperApp.Players.create_player()

    player
  end
end
