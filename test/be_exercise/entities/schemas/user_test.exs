defmodule BeExercise.Entities.Schemas.UserTest do
  use BeExercise.DataCase

  alias BeExercise.Entities.Schemas.User

  @valid_user %{
    name: "Mary Doe"
  }

  describe "User Schema" do
    test "with valid params" do
      assert %Ecto.Changeset{
               changes: changes,
               valid?: true,
               errors: []
             } = User.changeset(%User{}, @valid_user)

      assert @valid_user == changes
    end

    test "on empty params" do
      result = errors_on(User.changeset(%User{}, %{}))

      assert %{name: ["can't be blank"]} == result
    end

    test "errors on invalid name" do
      result = errors_on(User.changeset(%User{}, %{name: 130}))

      assert %{name: ["is invalid"]} == result
    end
  end
end
