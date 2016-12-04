defmodule Colorstorm.GradientLayer do
  use Colorstorm.Web, :model

  schema "gradient_layers" do
    field :angle, :decimal
    field :order, :integer
    field :gradient_type, :string
    belongs_to :gradient, Colorstorm.Gradient
    has_many :gradient_stops, Colorstorm.GradientStop

    timestamps
  end

  @required_fields ~w(angle order gradient_type gradient_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
