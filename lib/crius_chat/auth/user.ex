defmodule CriusChat.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias CriusChat.Auth.AuthToken

  schema "users" do
    field :email, :string
    field :nickname, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    has_many :auth_tokens, AuthToken
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:nickname, :email, :password])
    |> put_password_hash()
    |> unique_constraint(:email, downcase: true)
    |> validate_required([:nickname, :email, :password_hash])
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
