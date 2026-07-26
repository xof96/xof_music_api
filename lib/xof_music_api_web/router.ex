defmodule XofMusicApiWeb.Router do
  use Plug.Router

  plug(Plug.Logger)

  plug(:match)
  plug(:dispatch)

  get "/" do
    json(conn, 200, %{
      name: "Xof Music API",
      status: "ok",
      endpoints: %{
        discography: "api/artists/:artist_name/discography"
      }
    })
  end

  get "api/artists/:artist_name/discography" do
    case XofMusicApi.Music.get_discography(artist_name) do
      {:ok, discography} ->
        json(conn, 200, discography)

      {:error, :artist_not_found} ->
        json(conn, 404, %{
          error: "Artist not found"
        })

      {:error, reason} ->
        json(conn, 500, %{
          error: "Unable to retrieve discography",
          reason: inspect(reason)
        })
    end
  end

  match _ do
    json(conn, 404, %{
      error: "not_found",
      message: "Not Found"
    })
  end

  defp json(conn, status, body) do
    response = Jason.encode!(body)

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(status, response)
  end
end
