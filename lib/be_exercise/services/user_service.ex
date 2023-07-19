defmodule BeExercise.Services.UserService do
  @moduledoc """
   UserService contains business logic for Users
  """
  require Logger
  alias BeExercise.Entities.Users
  alias BeExercise.Clients.Emailer

  def get_users() do
    case list_users_with_active_salaries() do
      {:ok, users} ->
        {:ok, users}

      error ->
        Logger.error("Error when fetching users: #{inspect(error)}")

        error
    end
  end

  def get_users_by_name(%{"name" => name}), do: {:ok, Users.get_by(name)}

  def invite_users() do
    case list_users_with_active_salaries() do
      {:ok, users} ->
        {:ok, notify_users_mail(users)}

      error ->
        Logger.error("Error to invite users through email #{inspect(error)}")

        error
    end
  end

  defp notify_users_mail(users) do
    Enum.map(users, fn user ->
      Task.async(fn ->
        send_email(user)
      end)
    end)
    |> Enum.map(&Task.await/1)
  end

  defp send_email(user) do
    case Emailer.send_email(%{name: user.name}) do
      {:ok, response} ->
        response

      {:error, error} ->
        {:error, error}
    end
  end

  defp list_users_with_active_salaries(), do: {:ok, Users.list_with_active_salaries()}
end
