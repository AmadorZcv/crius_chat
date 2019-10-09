defmodule CriusChatWeb.ChatView do
  use CriusChatWeb, :view

  def render("room.json", %{room: room, public_key: public_key}) do
    %{data: %{room: room, public_key: public_key}}
  end
end
