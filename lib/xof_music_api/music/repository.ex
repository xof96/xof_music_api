defmodule XofMusicApi.Music.Repository do
  import Ecto.Query

  alias XofMusicApi.Repo
  alias XofMusicApi.Music.{Artist, Album}

  def get_artist_with_albums(artist_name) do
    Artist
    |> where([artist], artist.name == ^artist_name)
    |> preload(:albums)
    |> Repo.one()
  end

  def create_artist(attrs) do
    %Artist{}
    |> Artist.changeset(attrs)
    |> Repo.insert()
  end

  def create_album(attrs) do
    %Album{}
    |> Album.changeset(attrs)
    |> Repo.insert()
  end

  def create_artist_with_albums(artist_attrs, album_list) do
    Repo.transaction(fn ->
      with {:ok, artist} <- create_artist(artist_attrs),
           {:ok, albums} <- create_albums(album_list, artist.id) do
        %{artist | albums: albums}
      else
        {:error, reason} ->
          Repo.rollback(reason)
      end
    end)
  end

  defp create_albums(album_list, artist_id) do
    Enum.reduce_while(album_list, {:ok, []}, fn album_attrs, {:ok, albums} ->
      attrs = Map.put(album_attrs, :artist_id, artist_id)

      case create_album(attrs) do
        {:ok, album} ->
          {:cont, {:ok, [album | albums]}}

        {:error, changeset} ->
          {:halt, {:error, changeset}}
      end
    end)
    |> case do
      {:ok, albums} -> {:ok, Enum.reverse(albums)}
      error -> error
    end
  end
end
