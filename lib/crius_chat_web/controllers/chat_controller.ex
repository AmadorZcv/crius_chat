defmodule CriusChatWeb.ChatController do
  use CriusChatWeb, :controller

  def talk_to(conn, %{"user_id" => user_id}) do
    CriusChatWeb.Endpoint.broadcast!("user:" <> user_id, "open_convo", %{message: "MEssage"})

    conn
    |> send_resp(200, "ok")
  end
end
