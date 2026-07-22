defmodule XofMusicApi.Music.Album do
  use Ecto.Schema

  schema "albums" do
    field(:name, :string)
    field(:release_date, :date)

    belongs_to(:artist, XofMusicApi.Music.Artist)

    timestamps()
  end
end
