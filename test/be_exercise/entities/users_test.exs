defmodule BeExercise.Entities.UsersTest do
  use BeExercise.DataCase

  import BeExercise.Factory

  alias BeExercise.Entities.Users

  @valid_user %{
    name: "Mary Doe"
  }

  describe "User entity" do
    test "creates a new user" do
      assert {:ok, result} = Users.create(@valid_user)

      assert result.name == @valid_user.name
    end

    test "gets an existent user" do
      user = insert!(:user)

      assert result = Users.get(user.id)

      assert result.name == "John Doe"
    end

    test "list the existent users" do
      insert!(:user)
      insert!(:user)

      assert result = Users.list()

      assert 2 == length(result)
    end

    test "list the existent users with active salaries" do
      first_user = insert!(:user)

      insert!(:salary, %{
        user_id: first_user.id,
        amount: 999,
        currency: "BRL",
        active: true
      })

      second_user = insert!(:user)

      insert!(:salary, %{
        user_id: second_user.id,
        amount: 500,
        currency: "JPY",
        active: true
      })

      insert!(:salary, user_id: first_user.id, active: false)

      insert!(:salary, user_id: second_user.id, active: false)

      assert result = Users.list_with_active_salaries()

      assert 2 == length(result)
    end

    test "list the users ordered by its name" do
      first_user = insert!(:user, name: "Mary Doe")

      insert!(:salary, %{
        user_id: first_user.id,
        amount: 999,
        currency: "BRL",
        active: true
      })

      second_user = insert!(:user, name: "Alan Turing")

      insert!(:salary, %{
        user_id: second_user.id,
        amount: 500,
        currency: "JPY",
        active: true
      })

      assert result = Users.list_with_active_salaries()

      assert "Alan Turing" == hd(result).name
    end

    test "gets the user by full name" do
      first_user = insert!(:user, name: "Mary Doe")

      insert!(:salary, %{
        user_id: first_user.id,
        amount: 999,
        currency: "BRL",
        active: true
      })

      second_user = insert!(:user, name: "Alan Turing")

      insert!(:salary, %{
        user_id: second_user.id,
        amount: 500,
        currency: "JPY",
        active: true
      })

      assert result = Users.get_by("Alan Turing")

      [first | _] = result
      assert first.name == "Alan Turing"
    end

    test "gets the user by partial name" do
      first_user = insert!(:user, name: "Dorothy L. Phelan")

      insert!(:salary, %{
        user_id: first_user.id,
        amount: 999,
        currency: "BRL",
        active: true
      })

      second_user = insert!(:user, name: "Kenneth D. Mendelson")

      insert!(:salary, %{
        user_id: second_user.id,
        amount: 500,
        currency: "JPY",
        active: true
      })

      assert result = Users.get_by("Dorothy")

      [first | _] = result
      assert first.name == "Dorothy L. Phelan"
    end

    test "returns empty list when tries to get an user that does not exists" do
      assert [] = Users.get_by("John Doe")
    end
  end
end
