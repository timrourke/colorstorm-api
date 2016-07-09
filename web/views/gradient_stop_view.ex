defmodule Colorstorm.GradientStopView do
  use Colorstorm.Web, :view
  use JaSerializer.PhoenixView

  def type, do: "gradient-stops"

  location "/gradient-stops/:id"
  attributes [:left, :color, :inserted_at, :updated_at]
  
  has_one :gradient_layer,
    field: :gradient_layer_id,
    type: "gradient_layer"

end
