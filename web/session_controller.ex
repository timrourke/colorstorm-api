defmodule Colorstorm.SessionController  do
  use Colorstorm.Web, :controller

  def index(conn, _params) do
    conn
    |> json(%{status: "Ok you dog"})
  end
end