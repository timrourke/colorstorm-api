defmodule Colorstorm.Repo.Migrations.CreateGradientLayer do
  use Ecto.Migration

  def change do
    create table(:gradient_layers) do
      add :angle, :decimal
      add :order, :integer
      add :gradient_type, :string
      add :gradient_id, references(:gradients, on_delete: :nothing)

      timestamps
    end
    create index(:gradient_layers, [:gradient_id])

  end
end
