defmodule Colorstorm.Repo.Migrations.CreateGradientStop do
  use Ecto.Migration

  def change do
    create table(:gradient_stops) do
      add :left, :decimal
      add :color, :string
      add :gradient_layer_id, references(:gradient_layers, on_delete: :nothing)

      timestamps
    end
    create index(:gradient_stops, [:gradient_layer_id])

  end
end
