defmodule CriusChatWeb.Router do
  use CriusChatWeb, :router

  pipeline :authenticate do
    plug CriusChatWeb.Plugs.AuthenticatePlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Corsica, origins: "*"
  end

  scope "/", CriusChatWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/register", UserController, :new
    get "/sign_in", UserController, :sign_in
    post "/login", UserController, :login
    post "/create", UserController, :create
    delete "/logout", UserController, :logout
  end

  scope "/auth", CriusChatWeb do
    pipe_through :api
    post "/register", AuthController, :register
    post "/sign_in", AuthController, :sign_in
    delete "/sign_out", AuthController, :sign_out
  end

  # Other scopes may use custom stacks.
  scope "/api", CriusChatWeb do
    pipe_through :api
    pipe_through :authenticate

    get "/talk_to/:user_id", ChatController, :talk_to
  end
end
