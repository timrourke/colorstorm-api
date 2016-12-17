defmodule Colorstorm.RegistrationController do
  use Colorstorm.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias Colorstorm.User
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create]
  plug :put_view, Colorstorm.RegistrationView

  def create(conn, %{"data" => data = %{"type" => "users", "attributes" => _user_params}}) do
    changeset = User.changeset(%User{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, user} ->
        send_welcome_email(user)

        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render(Colorstorm.UserView, "show.json-api", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Colorstorm.UserView, "errors.json-api", data: changeset)
    end
  
  end

  defp send_welcome_email(user) do
    email_assigns = %{
      "hero_text" => "Welcome to ColorStorm!",
      "user" => user,
      "email_confirmation_link_url" => "https://fake.com/link?foo=bar"
    }
    
    Colorstorm.Email.welcome_html_email(email_assigns) 
    |> Colorstorm.Mailer.deliver_later
  end
end