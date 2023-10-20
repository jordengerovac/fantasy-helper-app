defmodule FantasyHelperApp.Players do
  require Logger
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false
  alias FantasyHelperApp.Repo

  alias FantasyHelperApp.Players.Player

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """
  def list_players do
    Repo.all(Player)
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{data: %Player{}}

  """
  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs)
  end

  defp csv_decoder(type) do
    file_path = if type === "batters" do
      "../../assets/data/mlb-player-stats-batters.csv"
    else
      if type === "pitchers" do
        "../../assets/data/mlb-player-stats-pitchers.csv"
      else
          raise "not a known type"
      end
    end
    file_path
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Enum.map(fn data -> data end)
  end

  @doc """
  Loads batting players from ../../assets/data/mlb-player-stats-batters.csv.

  ## Examples

      iex> load_batters()
      [
        ok: %{"2B" => "30", "3B" => "3", "AB" => "571", "AVG" => ".306", ...},
        ...
      ]

  """
  def load_batters() do
    data = csv_decoder("batters")
    for {:ok, element} <- data
    do
      name = Map.get(element, "\uFEFFPlayer")
      position = Map.get(element, "Pos")
      games_played = Map.get(element, "G")
      team = Map.get(element, "Team")
      type = "Batter"
      create_player(%{name: name, position: position, games_played: games_played, team: team, type: type})
    end
  end

  @doc """
  Loads pitching players from ../../assets/data/mlb-player-stats-pitchers.csv.

  ## Examples

      iex> load_pitchers()
      [
        ok: %{"Age" => "31", "BB" => "54", "BS" => "0", "CG" => "1", ...},
        ...
      ]

  """
  def load_pitchers() do
    data = csv_decoder("pitchers")
    for {:ok, element} <- data
    do
      name = Map.get(element, "\uFEFFPlayer")
      position = "P"
      games_played = Map.get(element, "G")
      team = Map.get(element, "Team")
      type = "Pitcher"
      create_player(%{name: name, position: position, games_played: games_played, team: team, type: type})
    end
  end

  def compare_players_with_chat_gpt(player1, player2) do
    IO.puts("Comparing " <> player1 <> " & " <> player2)

    url = "https://api.openai.com/v1/chat/completions"
    body = Poison.encode!(%{
      model: "gpt-3.5-turbo",
      messages: [
        %{
          role: "system",
          content: "You are a helpful fantasy sports assistant for the MLB. I will give you two players and you will tell me which of the two is a better choice for a fantasy sports team with statistics from their last 10 games to back it up."
        },
        %{
          role: "user",
          content: player1 <> " or " <> player2
        }
      ]
    })
    headers = [{"Content-type", "application/json"}, {"Accept", "application/json"}, {"Authorization", "Bearer " <> System.get_env("CHAT_GPT_API_TOKEN")}]
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.post(url, body, headers, [timeout: 50_000, recv_timeout: 50_000]) do
      Poison.decode!(body)
    end
  end
end
