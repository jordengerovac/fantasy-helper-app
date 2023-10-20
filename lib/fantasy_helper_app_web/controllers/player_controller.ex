defmodule FantasyHelperAppWeb.PlayerController do
  use FantasyHelperAppWeb, :controller

  alias FantasyHelperApp.Players
  alias FantasyHelperApp.Players.Player

  action_fallback FantasyHelperAppWeb.FallbackController

  def index(conn, _params) do
    players = Players.list_players()
    render(conn, :index, players: players)
  end

  def create(conn, %{"player" => player_params}) do
    with {:ok, %Player{} = player} <- Players.create_player(player_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/players/#{player}")
      |> render(:show, player: player)
    end
  end

  def show(conn, %{"id" => id}) do
    player = Players.get_player!(id)
    render(conn, :show, player: player)
  end

  def update(conn, %{"id" => id, "player" => player_params}) do
    player = Players.get_player!(id)

    with {:ok, %Player{} = player} <- Players.update_player(player, player_params) do
      render(conn, :show, player: player)
    end
  end

  def delete(conn, %{"id" => id}) do
    player = Players.get_player!(id)

    with {:ok, %Player{}} <- Players.delete_player(player) do
      send_resp(conn, :no_content, "")
    end
  end

  def compare_players(conn, %{"player1" => player1, "player2" => player2}) do
    with response <- Players.compare_players_with_chat_gpt(player1, player2) do
      conn
      |> put_status(:ok)
      |> put_resp_header("location", ~p"/players/compare/#{player1}/#{player2}")
      |> render(:compare_players, response: response)
    end
  end
end
