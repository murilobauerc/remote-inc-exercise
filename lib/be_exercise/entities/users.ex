defmodule BeExercise.Entities.Users do
  @moduledoc """
  Represents the Users Entity
  """
  import Ecto.Query

  alias BeExercise.Entities.Schemas.User

  alias BeExercise.Repo

  @doc """
  Creates a new user
  """
  @spec create(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Get a user by id
  """
  @spec get(integer()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def get(id) do
    Repo.get(User, id)
  end

  @doc """
  List all users
  """
  @spec list() :: {:ok, list(User.t())} | {:error, Ecto.Changeset.t()}
  def list do
    Repo.all(User)
  end

  @doc """
  Get a user by name or its partial name
  """
  @spec get_by(String.t()) :: {:ok, list(User.t())} | {:error, Ecto.Changeset.t()}
  def get_by(name) do
    Repo.all(
      from user in User,
        join: salary in assoc(user, :salaries),
        where: ilike(user.name, ^"%#{name}%") and salary.active == true,
        select: %{user | salaries: [salary]}
    )
  end

  @doc """
  List all users that has active salaries, ordering by name
  """
  @spec list_with_active_salaries() :: {:ok, list(User.t())} | {:error, Ecto.Changeset.t()}
  def list_with_active_salaries do
    Repo.all(
      from user in User,
        join: salary in assoc(user, :salaries),
        where: salary.active == true,
        order_by: [asc: user.name],
        select: %{user | salaries: [salary]}
    )
  end
end
