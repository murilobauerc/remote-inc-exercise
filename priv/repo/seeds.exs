# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BeExercise.Repo.insert!(%BeExercise.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule Repo.Seeds.UserSeeds do
  require Logger

  alias BeExercise.Entities.{Users, Salaries}
  alias BeExercise.Entities.Types.CurrencyType
  alias Faker

  @currency_types CurrencyType.__valid_values__()

  def create_user do
    %{
      name: Faker.Person.name()
    }
    |> Users.create()
    |> include_user_salaries()
  end

  def include_user_salaries({:ok, user}) do
    active_index = Enum.random(1..2)

    Enum.each(1..2, fn index ->
      %{
        currency: Enum.random(@currency_types),
        active: index == active_index,
        amount: Enum.random(50..500)
      }
      |> Salaries.create(user.id)
    end)
    |> case do
      {:ok, salaries} ->
        {:ok, %{user | salaries: salaries}}

      error ->
        error
    end
  end
end

defmodule Repo.Seeds do
  def create_list(size, create_fn) do
    IO.puts("Creating 20000 users into the database...")

    start_time = System.monotonic_time()

    1..size
    |> Task.async_stream(fn _ -> create_fn.() end)
    |> Enum.to_list()

    end_time = System.monotonic_time()

    time_difference = end_time - start_time

    time_difference_seconds = System.convert_time_unit(time_difference, :native, :second)

    IO.puts("Seed time execution: #{time_difference_seconds} seconds")
  end
end

alias Repo.Seeds
alias Repo.Seeds.UserSeeds

Seeds.create_list(20000, &UserSeeds.create_user/0)
