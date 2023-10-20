defmodule FantasyHelperAppWeb.DefaultController do
  use FantasyHelperAppWeb, :controller

  def index(conn, _params) do
    text conn, "Fantasy Helper App is live - #{Mix.env()}"
  end
end
