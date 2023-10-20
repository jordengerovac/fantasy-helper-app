defmodule FantasyHelperApp.Repo do
  use Ecto.Repo,
    otp_app: :fantasy_helper_app,
    adapter: Ecto.Adapters.Postgres
end
