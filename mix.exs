defmodule XofMusicApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :xof_music_api,
      version: "0.1.0",
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {XofMusicApi.Application, []}
    ]
  end

  defp deps do
    [
      {:bandit, "~> 1.12"},
      {:ecto_sql, "~> 3.14"},
      {:jason, "~> 1.4"},
      {:plug, "~> 1.20"},
      {:postgrex, "~> 0.21"},
      {:req, "~> 0.6"}
    ]
  end
end
