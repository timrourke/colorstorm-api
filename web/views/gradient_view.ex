defmodule Colorstorm.GradientView do
  use Colorstorm.Web, :view
  use JaSerializer.PhoenixView

  def type, do: "gradients"

  location "/gradients/:id"
  attributes [:body, :body_autoprefixed, :description, :permalink, :title, :inserted_at, :updated_at]

  has_one :user,
    field: :user_id,
    type: "users",
    serializer: Colorstorm.UserView,
    include: false

  def user(gradient, conn) do
    include = Map.get(conn.params, "include")
    cond do
      include && "user" in String.split(include, ",") ->
        Map.get(gradient, :user)
      true ->
        Map.get(gradient, :user_id)  
    end
  end

  has_many :gradient_layers, links: [
    related: "/gradients/:id/gradient-layers"
  ]

end
