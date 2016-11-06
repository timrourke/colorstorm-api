defmodule Colorstorm.UserView do
  use Colorstorm.Web, :view
  use JaSerializer.PhoenixView
  import Ecto.Query, only: [from: 2]

  def type, do: "users"

  attributes [:email, :username, :inserted_at, :updated_at]
  
  has_many :gradients,
    type: "gradients",
    serializer: Colorstorm.GradientView,
    include: false,
    link: :gradients_link

  def gradients(user, conn) do
    include = Map.get(conn.params, "include")
    cond do
      include && "gradients" in String.split(include, ",") ->
        Map.get(user, :gradients)
      true ->
        query = from g in Colorstorm.Gradient,
          select: g.id,
          where: g.user_id == ^user.id
        Colorstorm.Repo.all(query)
    end
  end

  def gradients_link(user, conn) do
    Colorstorm.Router.Helpers.user_gradient_url(conn, :index, user.id)
  end

end
