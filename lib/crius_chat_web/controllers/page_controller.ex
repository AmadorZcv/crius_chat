defmodule CriusChatWeb.PageController do
  use CriusChatWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
