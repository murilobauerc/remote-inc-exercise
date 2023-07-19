defmodule BeExercise.Entities.Schemas.User do
  @moduledoc """
    Represents the User schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias BeExercise.Entities.Schemas.Salary

  @mandatory_fields [
    :name
  ]

  @derive {Jason.Encoder, only: [:name, :salaries]}
  schema "users" do
    field :name, :string
    has_many :salaries, Salary
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @mandatory_fields)
    |> validate_required(@mandatory_fields)
  end
end
