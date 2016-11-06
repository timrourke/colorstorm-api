defmodule Colorstorm.Repo.Migrations.ChangeColorToRgba do
  use Ecto.Migration

  def change do
		alter table(:gradient_stops) do
			add :r, :integer, default: 0
			add :g, :integer, default: 0
			add :b, :integer, default: 0
			add :a, :decimal, default: 1

			remove :color
		end
  end
end
