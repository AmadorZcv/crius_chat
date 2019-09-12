defmodule CriusChat.Repo do
  use Ecto.Repo,
    otp_app: :crius_chat,
    adapter: Ecto.Adapters.Postgres
end
