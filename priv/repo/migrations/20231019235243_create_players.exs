defmodule FantasyHelperApp.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :type, :string
      add :position, :string
      add :team, :string
      add :games_played, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
