defmodule XofMusicApi.Repo do
  use Ecto.Repo,
    otp_app: :xof_music_api,
    adapter: Ecto.Adapters.Postgres
end
