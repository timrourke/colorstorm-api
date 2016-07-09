defmodule Colorstorm.Repo.Migrations.CreateGradient do
  use Ecto.Migration

  def change do
    create table(:gradients) do
      add :body, :text
      add :body_autoprefixed, :text
      add :description, :text
      add :permalink, :string
      add :title, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:gradients, [:user_id])

  end
end
