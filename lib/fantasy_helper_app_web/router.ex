defmodule FantasyHelperAppWeb.Router do
  use FantasyHelperAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug.GraphiQL,
      schema: FantasyHelperAppWeb.Schema,
      interface: :simple,
      context: %{pubsub: FantasyHelperAppWeb.Endpoint}
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
