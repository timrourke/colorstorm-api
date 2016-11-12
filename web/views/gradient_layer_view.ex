defmodule Colorstorm.GradientLayerView do
  use Colorstorm.Web, :view
  use JaSerializer.PhoenixView
  import Ecto.Query, only: [from: 2]
  import Colorstorm.Router, only: [api_url: 0]

  # api_url = "http://localhost:4000/api"

  def type, do: "gradient-layers"

  location "/api/gradient-layers/:id"
  attributes [:angle, :order, :gradient_type, :inserted_at, :updated_at]
  
  has_one :gradient,
    field: :gradient_id,
    type: "gradients",
    serializer: Colorstorm.GradientView,
    include: false,
    link: :gradients_link

  def gradient(gradientLayer, conn) do
    include = Map.get(conn.params, "include")
    cond do
      include && "gradient" in String.split(include, ",") ->
        Map.get(gradientLayer, :gradient)
      true ->
        Map.get(gradientLayer, :gradient_id)
    end
  end

  def gradients_link(gradientLayer, conn) do
    Colorstorm.Router.Helpers.gradient_layer_gradient_url(conn, :index, gradientLayer.id)
  end

  has_many :gradient_stops,
    type: "gradient-stops",
    serializer: Colorstorm.GradientStopView,
    identifiers: :always,
    include: false,
    link: :gradient_stops_link

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

  def gradient_stops_link(gradientLayer, conn) do
    Colorstorm.Router.Helpers.gradient_layer_gradient_stop_url(conn, :index, gradientLayer.id)
  end

end
