defmodule CriusChatWeb.FallbackController do
  use CriusChatWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(CriusChatWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, msg}) do
    conn
    |> put_status(422)
    |> put_view(CriusChatWeb.ErrorView)
    |> render("error.json", message: msg)
  end

  def call(conn, {:api_error, msg}) do
    conn
    |> put_status(417)
    |> put_view(CriusChatWeb.ErrorView)
    |> render("error.json", message: msg)
  end

  def call(conn, {:login_error, msg}) do
    conn
    |> put_status(425)
    |> put_view(CriusChatWeb.ErrorView)
    |> render("error.json", message: msg)
  end

  def call(conn, {:error_web, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(CriusChatWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error_web, :error_expired_invitation}) do
    conn
    |> put_status(:not_found)
    # Invitation Template...
    |> render("expired_invitation.html")
  end

  def call(conn, {:error_web, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(CriusChatWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end
end
