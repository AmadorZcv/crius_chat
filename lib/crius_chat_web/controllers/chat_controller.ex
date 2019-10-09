defmodule CriusChatWeb.ChatController do
  use CriusChatWeb, :controller

  def talk_to(conn, %{"user_id" => user_id}) do
    nickname = conn.assigns[:user_nickname]

    room_name =
      Enum.sort([user_id, nickname])
      |> Enum.join(":")

    public_key = Enum.random(1..11)

    CriusChatWeb.Endpoint.broadcast!("user:" <> user_id, "open_convo", %{
      room: "private_chat:" <> room_name,
      public_key: public_key,
      nickname: nickname
    })

    conn
    |> put_status(:ok)
    |> render("room.json", %{room: "private_chat:" <> room_name, public_key: public_key})
  end
end
