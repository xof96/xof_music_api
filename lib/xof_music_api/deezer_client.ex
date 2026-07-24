defmodule XofMusicApi.DeezerClient do
  @deezer_api_url "https://api.deezer.com"
  @deezer_search_url "https://api.deezer.com/search/artist"

  def get_discography(artist) when is_binary(artist) do
    with {:ok, artist_id} <- find_artist(artist),
         {:ok, album_list} <- fetch_albums(artist_id) do
      {:ok,
       %{
         name: artist,
         deezer_id: artist_id,
         albums: album_list
       }}
    end
  end

  defp find_artist(artist) do
    case Req.get(
           @deezer_search_url,
           params: [
             q: artist
           ]
         ) do
      {:ok, %{status: 200, body: %{"data" => data}}} ->
        case get_strict_artist_id(data, artist) do
          nil -> {:error, :artist_not_found}
          artist_id -> {:ok, artist_id}
        end

      {:ok, %{status: 200, body: %{"error" => %{"type" => "ParameterException"}}}} ->
        {:error, :wrong_parameters}

      {:ok, response} ->
        {:error, {:deezer_api_error, response.status}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get_strict_artist_id(artist_list, artist_name) do
    artist_list
    |> Enum.filter(fn artist ->
      artist["name"] == artist_name
    end)
    |> Enum.max_by(
      fn artist -> artist["nb_fan"] end,
      fn -> nil end
    )
    |> case do
      nil -> nil
      artist -> artist["id"]
    end
  end

  defp fetch_albums(artist_id) do
    url = "#{@deezer_api_url}/artist/#{artist_id}/albums"

    case Req.get(
           url,
           params: [limit: 50]
         ) do
      {:ok, %{status: 200, body: %{"data" => album_list}}} ->
        albums = album_list |> Enum.map(&normalize_album/1)
        {:ok, albums}

      {:ok, response} ->
        {:error, {:deezer_api_error, response.status}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp normalize_album(%{
         "title" => title,
         "release_date" => release_date
       }) do
    %{
      name: title,
      release_date: parse_date(release_date)
    }
  end

  defp parse_date(nil), do: nil
  defp parse_date(""), do: nil

  defp parse_date(date) do
    case Date.from_iso8601(date) do
      {:ok, parsed_date} -> parsed_date
      {:error, _reason} -> nil
    end
  end
end
