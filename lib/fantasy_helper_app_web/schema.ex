defmodule FantasyHelperAppWeb.Schema do
  use Absinthe.Schema

  object :player do
    field :id, :id
    field :name, :string
    field :position, :string
    field :games_played, :integer
    field :type, :string
    field :team, :string
  end

  query do
    @desc "Get all players"
    field :all_players, non_null(list_of(non_null(:player))) do
      resolve(&FantasyHelperAppWeb.PlayerResolver.all_players/3)
    end

    @desc "Get player by id"
    field :player_by_id, non_null(:player) do
      arg :id, non_null(:id)

      resolve(&FantasyHelperAppWeb.PlayerResolver.get_player_by_id/3)
    end
  end

  mutation do
    @desc "Create a new player"
    field :create_player, :player do
      arg :name, non_null(:string)
      arg :team, non_null(:string)
      arg :games_played, non_null(:integer)
      arg :position, non_null(:string)
      arg :type, non_null(:string)

      resolve(&FantasyHelperAppWeb.PlayerResolver.create_player/3)
    end
  end
end
