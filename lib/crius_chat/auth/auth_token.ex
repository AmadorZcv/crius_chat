defmodule CriusChat.Auth.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "auth_tokens" do
    field :agent, :string
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    field :token, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(auth_token, attrs) do
    auth_token
    |> cast(attrs, [:agent, :revoked, :revoked_at, :token])
    |> validate_required([:agent, :revoked, :revoked_at, :token])
  end
end
