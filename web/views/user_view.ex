defmodule Colorstorm.UserView do
  use Colorstorm.Web, :view
  use JaSerializer.PhoenixView

  attributes [:email, :username, :password_hash, :inserted_at, :updated_at]
  

end
