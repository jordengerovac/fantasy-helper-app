defmodule FantasyHelperAppWeb.PlayerResolver do
  alias FantasyHelperApp.Players

  def all_players(_root, _args, _info) do
    {:ok, Players.list_players()}
  end

  def get_player_by_id(_root, args, _info) do
    case Players.get_player!(args.id) do
      nil ->
        {:error, "player id #{args.id} not found"}
      player ->
        {:ok, player}
    end
  end

  def create_player(_root, args, _info) do
    case Players.create_player(args) do
      {:ok, player} ->
        {:ok, player}
      _error ->
        {:error, "could not create player"}
    end
  end
end
