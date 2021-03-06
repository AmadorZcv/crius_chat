defmodule CriusChat.Services.Authenticator do
  @seed "VmjTRUwb4z87PKVgmtsJeof1HKufbyg"
  @secret "Y5Z3oL0mgkx9/gKDnUodLmkvdFDzgGpnh5ZWyoxj02M2NHALlrattIEJPWjTn8f5"

  def generate_token(id) do
    Phoenix.Token.sign(@secret, @seed, id, max_age: 86400)
  end

  def verify_token(token) do
    case Phoenix.Token.verify(@secret, @seed, token) do
      # 0 - User, 1 - Admin
      {:ok, id} -> {:ok, token, id}
      error -> error
    end
  end

  def get_auth_token(conn) do
    case extract_token(conn) do
      {:ok, token} -> verify_token(token)
      error -> error
    end
  end

  # extrai o token do conn
  defp extract_token(conn) do
    IO.puts("Aqui")
    IO.inspect(conn)

    case Plug.Conn.get_req_header(conn, "authorization") do
      [auth_header] ->
        {:ok, String.trim(auth_header)}

      _ ->
        case Plug.Conn.get_session(conn, :token) do
          nil ->
            {:error, :missing_auth_header}

          token ->
            {:ok, token.token}
        end
    end
  end
end
