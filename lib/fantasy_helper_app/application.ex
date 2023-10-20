defmodule FantasyHelperApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FantasyHelperAppWeb.Telemetry,
      FantasyHelperApp.Repo,
      {DNSCluster, query: Application.get_env(:fantasy_helper_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FantasyHelperApp.PubSub},
      # Start a worker by calling: FantasyHelperApp.Worker.start_link(arg)
      # {FantasyHelperApp.Worker, arg},
      # Start to serve requests, typically the last entry
      FantasyHelperAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FantasyHelperApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FantasyHelperAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
