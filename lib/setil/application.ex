defmodule Setil.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SetilWeb.Telemetry,
      Setil.Repo,
      {DNSCluster, query: Application.get_env(:setil, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Setil.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Setil.Finch},
      # Start a worker by calling: Setil.Worker.start_link(arg)
      # {Setil.Worker, arg},
      # Start to serve requests, typically the last entry
      SetilWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Setil.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SetilWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
