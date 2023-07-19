defmodule BeExerciseWeb.UserController do
  use BeExerciseWeb, :controller

  require Logger

  alias BeExercise.Services.UserService

  def show(conn, %{"name" => name} = params) do
    Logger.info("Fetching the users by name: #{name}")

    UserService.get_users_by_name(params)
    |> case do
      {:ok, filtered_users} ->
        conn
        |> put_status(:ok)
        |> json(%{data: filtered_users})

      error ->
        error
    end
  end

  def show(conn, _params) do
    Logger.info("Fetching the list of users and their salaries")

    UserService.get_users()
    |> case do
      {:ok, users} ->
        conn
        |> put_status(:ok)
        |> json(%{data: users})

      error ->
        error
    end
  end

  def invite_users(conn, _params) do
    Logger.info("Sending email to all active users")

    UserService.invite_users()
    |> case do
      {:ok, response} ->
        conn
        |> put_status(:ok)
        |> json(%{data: %{names: response, current_status: "invite_sent"}})

      error ->
        error
    end
  end
end
