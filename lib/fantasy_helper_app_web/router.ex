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
end
