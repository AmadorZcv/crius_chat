defmodule CriusChatWeb.ChatView do
  use CriusChatWeb, :view

  def render("room.json", %{room: room}) do
    %{data: %{room: room}}
  end
end
