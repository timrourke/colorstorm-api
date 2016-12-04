defmodule Colorstorm.Router do
  use Colorstorm.Web, :router

  # Unauthenticated requests
  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug JaSerializer.Deserializer
  end

  # Authenticated requests
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug JaSerializer.Deserializer
  end

  scope "/api", Colorstorm do
    pipe_through :api

    resources "/gradients", GradientController, except: [:new, :edit] do
      resources "/gradient-layers", GradientLayerController, except: [:new, :edit]
      resources "/users", UserController, except: [:new, :edit]      
    end

    resources "/gradient-layers", GradientLayerController, except: [:new, :edit] do
      resources "/gradients", GradientController, except: [:new, :edit]
      resources "/gradient-stops", GradientStopController, except: [:new, :edit]      
    end

    resources "/gradient-stops", GradientStopController, except: [:new, :edit] do
      resources "/gradient-layers", GradientLayerController, except: [:new, :edit]      
    end

    post "/register", RegistrationController, :create

    resources "/session", SessionController, only: [:index]

    resources "/users", UserController, except: [:new, :edit] do
      resources "/gradients", GradientController, except: [:new, :edit]
    end
  end

  def api_url do
    cfg = Application.get_env(:colorstorm, Colorstorm.Endpoint)
    host = cfg[:url][:host]
    port = cfg[:http][:port]
    url = "http://#{host}:#{port}/api"
  end
end
