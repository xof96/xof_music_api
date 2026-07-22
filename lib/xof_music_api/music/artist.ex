defmodule XofMusicApi.Music.Artist do
  use Ecto.Schema

  schema "artists" do
    field(:name, :string)
    field(:deezer_id, :integer)

    has_many(:albums, XofMusicApi.Music.Album)

    timestamps()
  end
end
