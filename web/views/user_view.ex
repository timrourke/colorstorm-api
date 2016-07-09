defmodule Colorstorm.UserView do
  use Colorstorm.Web, :view
  use JaSerializer.PhoenixView

  def type, do: "users"

  attributes [:email, :username, :inserted_at, :updated_at]
  
  has_many :gradients, links: [
    related: "/users/:id/gradients",
    #self: "/users/:id/relationships/gradients"
  ]

end
