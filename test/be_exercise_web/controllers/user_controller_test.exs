defmodule BeExerciseWeb.UserControllerTest do
  use BeExerciseWeb.ConnCase
  import BeExercise.Factory

  @get_users_list_response %{
    "data" => [
      %{
        "name" => "Enner Valencia",
        "salaries" => [
          %{
            "active" => true,
            "amount" => 1000,
            "currency" => "USD"
          }
        ]
      },
      %{
        "name" => "Mary Doe",
        "salaries" => [
          %{
            "active" => true,
            "amount" => 2000,
            "currency" => "USD"
          }
        ]
      }
    ]
  }

  @invited_users_response %{
    "data" => %{
      "current_status" => "invite_sent",
      "names" => [
        "Brady Runte",
        "Brennan Mills",
        "Dominic Cole",
        "Madelyn Bahringer"
      ]
    }
  }

  describe "GET /users" do
    test "when returns a list of users onboarded with active salaries", %{conn: conn} do
      first_user =
        insert!(:user, %{
          name: "Enner Valencia"
        })

      second_user =
        insert!(:user, %{
          name: "Mary Doe"
        })

      insert!(:salary, %{
        amount: 1000,
        active: true,
        user_id: first_user.id
      })

      insert!(:salary, %{
        active: false,
        user_id: first_user.id
      })

      insert!(:salary, %{
        amount: 2000,
        active: true,
        user_id: second_user.id
      })

      conn = get(conn, Routes.user_path(conn, :show))

      assert @get_users_list_response == json_response(conn, 200)
    end

    test "when returns an empty list when there's no users created", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show))

      assert %{
               "data" => []
             } == json_response(conn, 200)
    end
  end

  describe "GET /users with query params" do
    test "when returns user given the name filtered by the query params", %{conn: conn} do
      first_user =
        insert!(:user, %{
          name: "Joe J. Joyner"
        })

      second_user =
        insert!(:user, %{
          name: "Michael V. Rodriguez"
        })

      insert!(:salary, %{
        amount: 1000,
        active: true,
        user_id: first_user.id
      })

      insert!(:salary, %{
        active: false,
        user_id: first_user.id
      })

      insert!(:salary, %{
        amount: 2000,
        active: true,
        user_id: second_user.id
      })

      conn = get(conn, Routes.user_path(conn, :show), %{"name" => "Joyner"})

      assert %{
               "data" => [
                 %{
                   "name" => "Joe J. Joyner",
                   "salaries" => [
                     %{
                       "active" => true,
                       "amount" => 1000,
                       "currency" => "USD"
                     }
                   ]
                 }
               ]
             } == json_response(conn, 200)
    end

    test "returns when there is no users created", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :show), %{"name" => "Joyner"})

      assert %{
               "data" => []
             } == json_response(conn, 200)
    end
  end

  describe "POST /invite-users" do
    test "returns the invited users through email", %{conn: conn} do
      insert_users_and_salary()

      conn = post(conn, Routes.user_path(conn, :invite_users))

      assert @invited_users_response == json_response(conn, 200)
    end

    test "returns an empty list on invite_users when there's no users created", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :invite_users))

      assert %{
               "data" => %{
                 "current_status" => "invite_sent",
                 "names" => []
               }
             } == json_response(conn, 200)
    end

    defp insert_users_and_salary do
      user_salary_data = [
        %{name: "Madelyn Bahringer", amount: 1000},
        %{name: "Brady Runte", amount: 2000},
        %{name: "Dominic Cole", amount: 3000},
        %{name: "Brennan Mills", amount: 4000}
      ]

      Enum.map(user_salary_data, fn %{name: name, amount: amount} ->
        user = insert!(:user, %{name: name})
        salary = insert!(:salary, %{amount: amount, active: true, user_id: user.id})
        {user, salary}
      end)
    end
  end
end
