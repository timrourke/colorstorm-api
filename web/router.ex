defmodule Colorstorm.Router do
  use Colorstorm.Web, :router

  # Unauthenticated requests
  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  # Authenticated requests
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Colorstorm do
    pipe_through :api

    resources "session", SessionController, only: [:index]

    resources "user", UserController, except: [:new, :edit]
  end
end
