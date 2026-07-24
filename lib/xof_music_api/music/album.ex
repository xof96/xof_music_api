defmodule XofMusicApi.Music.Album do
  use Ecto.Schema
  import Ecto.Changeset

  schema "albums" do
    field(:name, :string)
    field(:release_date, :date)

    belongs_to(:artist, XofMusicApi.Music.Artist)

    timestamps()
  end

  def changeset(album, attrs) do
    album
    |> cast(attrs, [:name, :release_date, :artist_id])
    |> validate_required([:name, :artist_id])
  end
end
