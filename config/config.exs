import Config

config :xof_music_api, XofMusicApi.Repo,
  username: System.get_env("POSTGRES_USER", "postgres"),
  password: System.get_env("POSTGRES_PASSWORD", "postgres"),
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  database: System.get_env("POSTGRES_DB", "xof_music_api_dev"),
  port: String.to_integer(System.get_env("POSTGRES_PORT", "5432"))

config :xof_music_api,
  ecto_repos: [XofMusicApi.Repo]
