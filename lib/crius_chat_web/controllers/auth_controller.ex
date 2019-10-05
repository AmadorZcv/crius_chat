defmodule CriusChatWeb.AuthController do
  use CriusChatWeb, :controller
  alias CriusChat.Auth
  alias CriusChatWeb.ChangesetView
  action_fallback ServerWeb.FallbackAPIController

  def register(conn, %{"user" => user_params}) do
    case Auth.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("sign_up_success.json", %{id: user.id})

      {:error, changeset} ->
        IO.puts("Here")

        conn
        |> put_view(ChangesetView)
        |> render("error.json", changeset: changeset)
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
