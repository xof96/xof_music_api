defmodule XofMusicApi.Repo.Migrations.CreateArtistsAndAlbums do
  use Ecto.Migration

  def change do
    create table(:artists) do
      add :name, :string, null: false
      add :deezer_id, :integer, null: false

      timestamps()
    end

    create unique_index(:artists, [:deezer_id])

    create table(:albums) do
      add :name, :string, null: false
      add :release_date, :date

      add :artist_id,
          references(:artists, on_delete: :delete_all),
          null: false

      timestamps()
    end
  end
end
