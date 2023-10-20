defmodule FantasyHelperApp.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "players" do
    field :games_played, :integer
    field :name, :string
    field :position, :string
    field :team, :string
    field :type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :type, :position, :team, :games_played])
    |> validate_required([:name, :type, :position, :team, :games_played])
  end
end
