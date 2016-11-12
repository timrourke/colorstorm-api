defmodule Colorstorm.GradientView do
  use Colorstorm.Web, :view
  use JaSerializer.PhoenixView
  import Ecto.Query, only: [from: 2]

  def type, do: "gradients"

  location "/gradients/:id"
  attributes [:body, :body_autoprefixed, :description, :permalink, :title, :inserted_at, :updated_at]

  has_one :user,
    field: :user_id,
    type: "users",
    serializer: Colorstorm.UserView,
    include: false,
    link: :user_link

  def user(gradient, conn) do
    include = Map.get(conn.params, "include")
    cond do
      include && "user" in String.split(include, ",") ->
        Map.get(gradient, :user)
      true ->
        Map.get(gradient, :user_id)  
    end
  end

  def user_link(gradient, conn) do
    Colorstorm.Router.Helpers.gradient_user_url(conn, :index, gradient.id)
  end

  has_many :gradient_layers,
    type: "gradient-layers",
    serializer: Colorstorm.GradientLayerView,
    include: false,
    link: :gradient_layers_link

  def gradient_layers(gradient, conn) do
    include = Map.get(conn.params, "include")
    cond do
      include && "gradient-layers" in String.split(include, ",") ->
        Map.get(gradient, :gradient_layers)
      true ->
        query = from gl in Colorstorm.GradientLayer,
          select: gl.id,
          where: gl.gradient_id == ^gradient.id
        Colorstorm.Repo.all(query)  
    end
  end

  def gradient_layers_link(gradient, conn) do
    Colorstorm.Router.Helpers.gradient_gradient_layer_url(conn, :index, gradient.id)
  end

end
