defmodule CriusChatWeb.AuthView do
  use CriusChatWeb, :view

  def render("sign_up_success.json", %{id: id}) do
    %{
      status: :ok,
      id: id,
      message: """
      Registrado com sucesso.
      """
    }
  end

  def render("show.json", %{auth_token: auth_token, nickname: nickname}) do
    %{data: %{token: auth_token, nickname: nickname}}
  end
end
