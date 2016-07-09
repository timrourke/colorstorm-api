defmodule Colorstorm.GradientLayerView do
  use Colorstorm.Web, :view
  use JaSerializer.PhoenixView
  import Ecto.Query, only: [from: 2]

  def type, do: "gradient-layers"

  location "/gradient-layers/:id"
  attributes [:angle, :order, :gradient_type, :inserted_at, :updated_at]
  
  has_one :gradient,
    field: :gradient_id,
    type: "gradients",
    serializer: Colorstorm.GradientView,
    include: false

  def gradient(gradientLayer, conn) do
    include = Map.get(conn.params, "include")
    cond do
      include && "gradient" in String.split(include, ",") ->
        Map.get(gradientLayer, :gradient)
      true ->
        Map.get(gradientLayer, :gradient_id)
    end
  end

  has_many :gradient_stops,
    type: "gradient-stops",
    serializer: Colorstorm.GradientStopView,
    include: false

  # has_many :gradient_stops, links: [
  #   related: "/gradient-layers/:id/gradient-stops",
  #   #self: "/users/:id/relationships/gradients"
  # ]

  def gradient_stops(gradientLayer, conn) do
    include = Map.get(conn.params, "include")
    cond do
      include && "gradient-stops" in String.split(include, ",") ->
        Map.get(gradientLayer, :gradient_stops)
      true ->
        query = from gs in Colorstorm.GradientStop,
          select: gs.id,
          where: gs.gradient_layer_id == ^gradientLayer.id
        Colorstorm.Repo.all(query)
    end
  end

end
