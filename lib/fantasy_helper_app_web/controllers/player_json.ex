defmodule FantasyHelperAppWeb.PlayerJSON do
  alias FantasyHelperApp.Players.Player

  @doc """
  Renders a list of players.
  """
  def index(%{players: players}) do
    %{data: for(player <- players, do: data(player))}
  end

  @doc """
  Renders a single player.
  """
  def show(%{player: player}) do
    %{data: data(player)}
  end

   @doc """
  Renders a json respnse.
  """
  def compare_players(%{response: response}) do
    %{data: response}
  end

  defp data(%Player{} = player) do
    %{
      id: player.id,
      name: player.name,
      type: player.type,
      position: player.position,
      team: player.team,
      games_played: player.games_played
    }
  end
end
