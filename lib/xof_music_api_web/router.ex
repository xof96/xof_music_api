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
        health: "/health",
        artists: "/api/artists"
      }
    })
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
