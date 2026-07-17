defmodule XofMusicApi.DeezerClient do
  @deezer_api_url "https://api.deezer.com"
  @deezer_search_url "https://api.deezer.com/search/artist"

  def get_discography(artist) when is_binary(artist) do
    with {:ok, artist_id} <- find_artist(artist),
         {:ok, album_list} <- fetch_albums(artist_id) do
      {:ok, album_list}
    end
  end

  def find_artist(artist) do
    case Req.get(
           @deezer_search_url,
           params: [
             q: artist,
             # Doesn't seem to work so we implement our own strict search with get_strict_artist_id
             strict: "on"
           ]
         ) do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        {:ok, data |> get_strict_artist_id(artist)}

      {:ok, %{status: 200, body: %{"error" => %{"type" => "ParameterException"}}}} ->
        {:error, :wrong_parameters}

      {:ok, response} ->
        {:error, {:deezer_api_error, response.status}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def fetch_albums(artist_id) do
    case Req.get(
           "#{@deezer_api_url}/artist/#{artist_id}/albums",
           params: [limit: 50]
         ) do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        {:ok, data}

      {:ok, response} ->
        {:ok, response}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def get_strict_artist_id(artist_list, artist_name) do
    with [artist_body] <-
           artist_list
           |> Enum.filter(fn artist ->
             artist["name"] == artist_name
           end) do
      artist_body |> Map.get("id")
    else
      [] ->
        nil

      artists ->
        artists
        |> Enum.max_by(fn artist -> artist["nb_fan"] end)
        |> Map.get("id")
    end
  end
end
