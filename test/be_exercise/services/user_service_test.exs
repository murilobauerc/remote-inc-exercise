defmodule BeExercise.Services.UserServiceTest do
  use BeExercise.DataCase

  import BeExercise.Factory

  alias BeExercise.Services.UserService

  describe "UserService.get_users/0" do
    test "returns success when get the list of active users" do
      first_user =
        insert!(:user, %{
          name: "Enner Valencia"
        })

      second_user =
        insert!(:user, %{
          name: "Mary Doe"
        })

      insert!(:salary, %{
        amount: 5500,
        active: true,
        currency: "JPY",
        user_id: first_user.id
      })

      insert!(:salary, %{
        amount: 2100,
        active: true,
        currency: "GBP",
        user_id: second_user.id
      })

      assert {:ok, result} = UserService.get_users()

      assert 2 == length(result)

      user1 = List.first(result)
      assert user1.name == "Enner Valencia"
      assert 1 == length(user1.salaries)

      salary1 = List.first(user1.salaries)
      assert salary1.amount == 5500
      assert salary1.currency == :JPY

      user2 = List.last(result)
      assert user2.name == "Mary Doe"
      assert 1 == length(user2.salaries)

      salary2 = List.first(user2.salaries)
      assert salary2.amount == 2100
      assert salary2.currency == :GBP
    end

    test "returns empty list when there is no users created" do
      assert {:ok, result} = UserService.get_users()

      assert [] = result
      assert 0 == length(result)
    end
  end

  describe "UserService.invite_users/0" do
    test "successfully sends email invite to active users" do
      first_user =
        insert!(:user, %{
          name: "Jamir Simonis"
        })

      second_user =
        insert!(:user, %{
          name: "Shirley McDermott"
        })

      insert!(:salary, %{
        amount: 800_000,
        active: true,
        currency: "EUR",
        user_id: first_user.id
      })

      insert!(:salary, %{
        amount: 6_500_000,
        active: true,
        currency: "BRL",
        user_id: second_user.id
      })

      assert {:ok, result} = UserService.invite_users()

      assert ["Jamir Simonis", "Shirley McDermott"] == result
      assert length(result) == 2
    end

    test "does not send email invite when there is no users" do
      assert {:ok, []} = UserService.invite_users()
    end
  end

  describe "UserService.get_users_by_name/1" do
    test "successfully get users by its full name" do
      first_user =
        insert!(:user, %{
          name: "Stacy T. Sanabria"
        })

      second_user =
        insert!(:user, %{
          name: "Robert R. May"
        })

      insert!(:salary, %{
        amount: 510_000,
        active: true,
        currency: "EUR",
        user_id: first_user.id
      })

      insert!(:salary, %{
        amount: 2_500_000,
        active: true,
        currency: "BRL",
        user_id: second_user.id
      })

      assert {:ok, result} = UserService.get_users_by_name(%{"name" => "Stacy T. Sanabria"})

      [user | _] = result
      assert user.name == "Stacy T. Sanabria"
    end

    test "sucessfully get users by its partial name" do
      first_user =
        insert!(:user, %{
          name: "Karen B. Miles"
        })

      second_user =
        insert!(:user, %{
          name: "Jimmy T. Gaul"
        })

      insert!(:salary, %{
        amount: 510_000,
        active: true,
        currency: "EUR",
        user_id: first_user.id
      })

      insert!(:salary, %{
        amount: 2_500_000,
        active: true,
        currency: "BRL",
        user_id: second_user.id
      })

      assert {:ok, result} = UserService.get_users_by_name(%{"name" => "Miles"})

      [user | _] = result
      assert user.name == "Karen B. Miles"
    end

    test "fails when tries to get an invalid user name" do
      assert {:ok, []} = UserService.get_users_by_name(%{"name" => 00})
    end
  end
end
