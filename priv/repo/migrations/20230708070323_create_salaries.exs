defmodule BeExercise.Repo.Migrations.CreateSalaries do
  use Ecto.Migration

  def change do
    create table(:salaries) do
      add :currency, :string, null: false
      add :active, :boolean, default: false
      add :amount, :integer, null: false
      add :user_id, references(:users)

      timestamps()
    end

    create index(:salaries, [:user_id])
  end
end
