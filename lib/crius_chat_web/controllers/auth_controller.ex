defmodule CriusChatWeb.AuthController do
  use CriusChatWeb, :controller
  alias CriusChat.Auth

  def registrar(conn, %{"usuario" => usuario_params}) do
    with {:ok, usuario} <- Auth.create_user(usuario_params) do
      conn
      |> put_status(:created)
      |> render("sign_up_success.json", %{id: usuario.id})
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.sign_in(email, password, "api") do
      {:ok, auth_token} ->
        conn
        |> put_status(:ok)
        |> render("show.json", auth_token)

      {:error, reason} ->
        conn
        |> send_resp(401, reason)
    end
  end

  def sign_out(conn, _) do
    case Auth.sign_out(conn) do
      {:error, reason} -> conn |> send_resp(400, reason)
      {:ok, _} -> conn |> send_resp(204, "")
    end
  end
end