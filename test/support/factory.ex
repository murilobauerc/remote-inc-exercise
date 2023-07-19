defmodule BeExercise.Factory do
  @moduledoc """
  Helper module to create and save entities in the database
  """
  alias BeExercise.Entities.Schemas.{
    User,
    Salary
  }

  alias BeExercise.Repo

  def build(:user) do
    %User{
      name: "John Doe"
    }
  end

  def build(:salary) do
    %Salary{
      active: false,
      currency: "USD",
      amount: 1000
    }
  end

  def build(factory_name, attr) do
    factory_name
    |> build()
    |> struct(attr)
  end

  def insert!(factory_name, attr \\ []) do
    build(factory_name, attr)
    |> Repo.insert!()
  end
end
