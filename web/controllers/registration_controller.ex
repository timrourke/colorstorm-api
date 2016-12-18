defmodule Colorstorm.RegistrationController do
  use Colorstorm.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias Colorstorm.User
  alias Colorstorm.Redis
  alias JaSerializer.Params
  require Logger

  plug :scrub_params, "data" when action in [:create]
  plug :put_view, Colorstorm.RegistrationView

  def create(conn, %{"data" => data = %{"type" => "users", "attributes" => _user_params}}) do
    changeset = User.changeset(%User{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> send_welcome_email(user)
        |> test_redis(user)
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render(Colorstorm.UserView, "show.json-api", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Colorstorm.UserView, "errors.json-api", data: changeset)
    end
  
  end

  defp send_welcome_email(conn, user) do
    email_assigns = %{
      "hero_text" => "Welcome to ColorStorm!",
      "user" => user,
      "email_confirmation_link_url" => "https://fake.com/link?foo=bar"
    }
    
    Colorstorm.Email.welcome_html_email(email_assigns) 
    |> Colorstorm.Mailer.deliver_later

    conn
  end

  defp test_redis(conn, user) do
    uuid = Ecto.UUID.generate()

    save_confirm_uuid = ~w(SET #{uuid} #{user.id}_#{user.email})

    case Redis.command(save_confirm_uuid, timeout: 1800000) do
      {:ok, message} -> Logger.info message
      {:error, error} -> Logger.error error
    end

    conn
  end
end