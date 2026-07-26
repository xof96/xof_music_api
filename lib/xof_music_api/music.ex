defmodule XofMusicApi.Music do
  alias XofMusicApi.DeezerClient
  alias XofMusicApi.Music.{Repository, Discography}

  def get_discography(artist_name) when is_binary(artist_name) do
    case Repository.get_artist_with_albums(artist_name) do
      nil ->
        fetch_and_store_discography(artist_name)

      artist ->
        {:ok, Discography.from_artist(artist)}
    end
  end

  defp fetch_and_store_discography(artist_name) do
    with {:ok, discography} <- DeezerClient.get_discography(artist_name) do
      artist_attrs = %{
        name: discography.name,
        deezer_id: discography.deezer_id
      }

      Repository.create_artist_with_albums(
        artist_attrs,
        discography.albums
      )
    end
  end
end
