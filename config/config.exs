import Config

config :xof_music_api, XofMusicApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "xof_music_api_dev",
  port: 5432

config :xof_music_api,
  ecto_repos: [XofMusicApi.Repo]
