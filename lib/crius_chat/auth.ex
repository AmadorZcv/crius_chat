defmodule CriusChat.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias CriusChat.Repo

  alias CriusChat.Auth.User
  alias CriusChat.Auth.AuthToken
  alias CriusChat.Services.Authenticator

  def validate_user_token(id, token) do
    from(
      u in User,
      join: t in AuthToken,
      where: u.id == ^id and t.token == ^token and t.revoked == false
    )
    |> Repo.one()
  end

  def sign_in(email, password, agent) do
    case Bcrypt.check_pass(Repo.get_by(User, email: email), password) do
      {:ok, user} ->
        token = Authenticator.generate_token(user.id)
        Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token, agent: agent}))

      err ->
        err
    end
  end

  def sign_out(conn) do
    case Authenticator.get_auth_token(conn) do
      {:ok, token, _id} ->
        case Repo.get_by(AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token -> Repo.delete(auth_token)
        end

      error ->
        error
    end
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    IO.inspect(attrs)

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
