defmodule Colorstorm.GradientStopView do
  use Colorstorm.Web, :view
  use JaSerializer.PhoenixView

  def type, do: "gradient-stops"

  location "/gradient-stops/:id"
  attributes [:left, :r, :g, :b, :a, :inserted_at, :updated_at]
  
  has_one :gradient_layer,
    field: :gradient_layer_id,
    serializer: Colorstorm.GradientLayerView,
    type: "gradient-layers",
    include: false,
    link: :gradient_layer_link

  def gradient_layer(gradientStop, conn) do
    include = Map.get(conn.params, "include")
    cond do
      include && "gradient-layer" in String.split(include, ",") ->
        Map.get(gradientStop, :gradient_layer)
      true ->
        Map.get(gradientStop, :gradient_layer_id)
    end
  end

  def gradient_layer_link(gradientStop, conn) do
    Colorstorm.Router.Helpers.gradient_stop_gradient_layer_url(conn, :index, gradientStop.id)
  end

end
