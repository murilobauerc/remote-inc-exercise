defmodule BeExercise.Entities.Schemas.SalaryTest do
  use BeExercise.DataCase

  alias BeExercise.Entities.Schemas.Salary

  @valid_salary %{
    amount: 1000,
    active: true,
    currency: :USD
  }

  describe "Salary Schema" do
    test "with valid params" do
      assert %Ecto.Changeset{
               changes: changes,
               valid?: true,
               errors: []
             } = Salary.changeset(%Salary{}, @valid_salary)

      assert @valid_salary == changes
    end

    test "errors on empty params" do
      result = errors_on(Salary.changeset(%Salary{}, %{}))

      assert %{
               amount: ["can't be blank"],
               currency: ["can't be blank"]
             } == result
    end

    test "errors on invalid currency type" do
      invalid_salary = %{@valid_salary | currency: :invalid_currency}

      result = errors_on(Salary.changeset(%Salary{}, invalid_salary))

      assert %{currency: ["is invalid"]} == result
    end

    test "errors on invalid amount" do
      invalid_salary = %{@valid_salary | amount: "string_amount"}

      result = errors_on(Salary.changeset(%Salary{}, invalid_salary))

      assert %{amount: ["is invalid"]} == result
    end

    test "errors on invalid active status" do
      invalid_salary = %{@valid_salary | active: "other_value_than_boolean"}

      result = errors_on(Salary.changeset(%Salary{}, invalid_salary))

      assert %{active: ["is invalid"]} == result
    end
  end
end
