defmodule BeExercise.Entities.Schemas.Salary do
  @moduledoc """
    Represents the Salary schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias BeExercise.Entities.Schemas.User
  alias BeExercise.Entities.Types.CurrencyType

  @mandatory_fields [
    :currency,
    :active,
    :amount
  ]

  @derive {Jason.Encoder, only: [:currency, :active, :amount]}
  schema "salaries" do
    field :active, :boolean, default: false
    field :currency, CurrencyType
    field :amount, :integer
    belongs_to :user, User

    timestamps()
  end

  def changeset(salary, attrs) do
    salary
    |> cast(attrs, @mandatory_fields)
    |> validate_required(@mandatory_fields)
  end
end
