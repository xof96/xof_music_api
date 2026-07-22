defmodule XofMusicApi.Music.Repository do
  import Ecto.Query

  alias XofMusicApi.Repo
  alias XofMusicApi.Music.Artist

  def get_artist_with_albums(artist_name) do
    Artist
    |> where([artist], artist.name == ^artist_name)
    |> preload(:albums)
    |> Repo.one()
  end
end
