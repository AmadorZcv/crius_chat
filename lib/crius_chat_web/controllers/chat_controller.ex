defmodule CriusChatWeb.ChatController do
  use CriusChatWeb, :controller

  def talk_to(conn, %{"user_id" => user_id}) do
    nickname = conn.assigns[:user_nickname]

    room_name =
      Enum.sort([user_id, nickname])
      |> Enum.join(":")

    CriusChatWeb.Endpoint.broadcast!("user:" <> user_id, "open_convo", %{
      rooom: "private_chat:" <> room_name
    })

    conn
    |> put_status(:ok)
    |> render("room.json", %{room: "private_chat:" <> room_name})
  end
end
