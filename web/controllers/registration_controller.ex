defmodule Colorstorm.RegistrationController do
  use Colorstorm.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias Colorstorm.User
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create]

  def create(conn, %{"data" => data = %{"type" => "users", "attributes" => _user_params}}) do
    changeset = User.changeset(%User{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render(Colorstorm.UserView, "show.json", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Colorstorm.UserView, "errors.json-api", data: changeset)
    end
  
  end
end