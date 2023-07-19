defmodule BeExercise.Clients.Emailer do
  @moduledoc """
  This module defines the Emailer client
  """
  def send_email(params) do
    case env(:client).send_email(params) do
      {:ok, response} ->
        {:ok, response}

      {:error, error} ->
        {:error, error}
    end
  end

  defp env(key), do: Application.get_env(:be_exercise, __MODULE__)[key]
end
