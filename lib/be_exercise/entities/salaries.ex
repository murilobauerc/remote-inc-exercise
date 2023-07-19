defmodule BeExercise.Entities.Salaries do
  @moduledoc """
  Represents the Salaries Entity
  """
  alias BeExercise.Entities.Schemas.Salary

  alias BeExercise.Repo

  @doc """
  Creates a new salary
  """
  @spec create(map()) :: {:ok, Salary.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %Salary{}
    |> Salary.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
    Creates a new salary associated with a user
  """
  @spec create(attrs :: map(), user_id :: integer) ::
          {:ok, Salary.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs, user_id) do
    %Salary{user_id: user_id}
    |> Salary.changeset(attrs)
    |> Repo.insert()
  end
end
