defmodule CriusChatWeb.PageController do
  use CriusChatWeb, :controller

  def index(conn, _params) do
    IO.inspect(conn)
    render(conn, "index.html")
  end
end
