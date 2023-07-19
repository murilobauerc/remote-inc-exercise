defmodule BeExercise.Repo.Migrations.SetActiveFieldAsRequired do
  use Ecto.Migration

  def change do
    alter table(:salaries) do
      modify :active, :boolean, null: false
    end
  end
end
