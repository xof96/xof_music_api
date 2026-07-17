defmodule XofMusicApi.Application do
  use Application

  @impl true
  def start(_type, _args) do
    port = System.get_env("PORT", "4000") |> String.to_integer()

    children = [
      {Bandit, plug: XofMusicApiWeb.Router, scheme: :http, port: port}
    ]

    opts = [strategy: :one_for_one, name: XofMusicApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
