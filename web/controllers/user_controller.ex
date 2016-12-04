defmodule Colorstorm.UserController do
  use Colorstorm.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias Colorstorm.Gradient
  alias Colorstorm.User
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  @relationships ["gradients"]

  def index(conn, %{"gradient_id" => gradient_id}) do
    query = from u in User,
      join: g in Gradient, on: g.user_id == u.id,
      where: g.id == ^gradient_id,
      limit: 1
    user = Repo.all(query)
    render(conn, "index.json", data: user)
  end  

  def index(conn, %{"include" => include}) when include != "" do
    rel_string = String.replace(include, "-", "_")

    users = 
      rel_string
      |> String.split(",")
      |> Enum.filter(fn value -> value in @relationships end)
      |> Enum.map(fn value -> String.to_atom(value) end)
      |> user_query
      |> Repo.all

    render(conn, "index.json", data: users, opts: [include: rel_string])
  end

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", data: users)
  end

  defp user_query(value) do
    from u in User, preload: [^value]
  end

  def create(conn, %{"data" => data = %{"type" => "users", "attributes" => _user_params}}) do
    changeset = User.changeset(%User{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Colorstorm.UserView, "errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", data: user)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "users", "attributes" => _user_params}}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Colorstorm.UserView, "errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end

end
