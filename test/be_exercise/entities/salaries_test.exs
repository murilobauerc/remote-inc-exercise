defmodule BeExercise.Entities.SalariesTest do
  use BeExercise.DataCase

  import BeExercise.Factory

  alias BeExercise.Entities.Salaries

  @valid_salary %{
    amount: 1000,
    currency: :EUR,
    active: true
  }

  describe "Salary entity" do
    test "creates a new salary" do
      assert {:ok, result} = Salaries.create(@valid_salary)

      assert result.amount == @valid_salary.amount
      assert result.currency == @valid_salary.currency
    end

    test "creates a new salary associated with an user" do
      user = insert!(:user)

      assert {:ok, result} = Salaries.create(@valid_salary, user.id)

      assert result.amount == @valid_salary.amount
      assert result.currency == @valid_salary.currency
      assert result.user_id == user.id
    end
  end
end
