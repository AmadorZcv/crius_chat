defmodule CriusChatWeb.Plugs.AuthenticatePlug do
  import Plug.Conn
  alias CriusChat.Auth
  alias CriusChat.Services.Authenticator
  def init(default), do: default

  def call(conn, _default) do
    case Authenticator.get_auth_token(conn) do
      # 0 - User
      {:ok, token, id} ->
        case Auth.validate_user_token(id, token) do
          nil -> unauthorized(conn)
          user -> authorized_user(conn, user.id, user.nickname)
        end

      # 1 - Professor
      # {:ok, token, id, 1} ->
      # case Contas.validate_profissional_token(id, token) do
      #  nil -> unauthorized(conn)
      # profissional -> authorized_user(conn, profissional.id, :profissional)
      # end
      #
      _ ->
        unauthorized(conn)
    end
  end

  # role :user, :professor
  defp authorized_user(conn, id, nickname) do
    conn
    |> assign(:user_nickname, nickname)
    |> assign(:user_id, id)
  end

  defp unauthorized(conn) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt()
  end
end
