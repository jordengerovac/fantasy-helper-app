defmodule FantasyHelperAppWeb.Router do
  use FantasyHelperAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FantasyHelperAppWeb do
    pipe_through :api
    get "/", DefaultController, :index
  end

  scope "/players", FantasyHelperAppWeb do
    pipe_through :api
    get "/", PlayerController, :index
  end

  scope "/players/:id", FantasyHelperAppWeb do
    pipe_through :api
    get "/", PlayerController, :show
  end

  scope "/players/compare/:player1/:player2", FantasyHelperAppWeb do
    pipe_through :api
    get "/", PlayerController, :compare_players
  end
end
