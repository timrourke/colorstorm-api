defmodule Colorstorm.RegistrationController do
  use Colorstorm.Web, :controller

  alias Colorstorm.User

  def create(conn, %{
    "data" => %{  
      "type" => "users",
      "attributes" => %{
        "email" => email,
        "password" => password,
        "password-confirmation" => password_confirmation
      },
    }
  }) do

    changeset = User.changeset %User{}, %{
      email: email,
      password_confirmation: password_confirmation,
      password: password
    }

    case Repo.insert changeset do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(Colorstorm.UserView, "show.json", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Colorstorm.ChangesetView, "error.json", changeset: changeset)
    end
  
  end
end