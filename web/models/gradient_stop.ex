defmodule Colorstorm.GradientStop do
  use Colorstorm.Web, :model

  schema "gradient_stops" do
    field :left, :decimal
    field :r, :integer
    field :g, :integer
    field :b, :integer
    field :a, :decimal
    belongs_to :gradient_layer, Colorstorm.GradientLayer

    timestamps
  end

  @required_fields ~w(left r g b a gradient_layer_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
