defmodule XofMusicApi.Music.Discography do
  alias XofMusicApi.Music.Artist

  def from_artist(%Artist{} = artist) do
    %{
      name: artist.name,
      deezer_id: artist.deezer_id,
      albums: Enum.map(artist.albums, &album_to_map/1)
    }
  end

  defp album_to_map(album) do
    %{
      name: album.name,
      release_date: album.release_date
    }
  end
end
