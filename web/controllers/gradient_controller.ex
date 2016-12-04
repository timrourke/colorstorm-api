defmodule Colorstorm.GradientController do
  use Colorstorm.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias Colorstorm.Gradient
  alias Colorstorm.GradientLayer
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  @relationships ["user", "gradient_layers"]

  def index(conn, %{"user_id" => user_id}) do
    query = from g in Gradient,
      where: g.user_id == ^user_id
    gradients = Repo.all(query)

    render(conn, "index.json", data: gradients)
  end

  def index(conn, %{"gradient_layer_id" => gradient_layer_id}) do
    query = from g in Gradient,
      join: gl in GradientLayer, on: gl.gradient_id == g.id,
      where: gl.id == ^gradient_layer_id
    gradients = Repo.all(query)

    render(conn, "index.json", data: gradients)
  end

  def index(conn, %{"include" => include}) when include != "" do
    rel_string = String.replace(include, "-", "_")

    gradients = 
      rel_string
      |> String.split(",")
      |> Enum.filter(fn value -> value in @relationships end)
      |> Enum.map(fn value -> String.to_atom(value) end)
      |> gradient_query
      |> Repo.all

    render(conn, "index.json", 
      data: gradients, 
      opts: [include: rel_string])
  end

  def index(conn, _params) do
    gradients = Repo.all(Gradient)
    render(conn, "index.json", data: gradients)
  end

  defp gradient_query(value) do 
    from g in Gradient, preload: [^value]
  end

  def create(conn, %{"data" => data = %{"type" => "gradients", "attributes" => _gradient_params}}) do
    changeset = Gradient.changeset(%Gradient{}, Params.to_attributes(data))
    
    case Repo.insert(changeset) do
      {:ok, gradient} ->
        gradient = Ecto.Changeset.change gradient, 
          permalink: create_permalink(gradient.title, gradient.id)

        case Repo.update(gradient) do
          {:ok, gradient_with_permalink} ->
            conn
            |> put_status(:created)
            |> put_resp_header("location", gradient_path(conn, :show, gradient_with_permalink))
            |> render("show.json", data: gradient_with_permalink)    
          {:error, gradient} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Colorstorm.ChangesetView, "error.json", changeset: gradient)    
        end
          
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Colorstorm.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    gradient = Repo.get!(Gradient, id)
    render(conn, "show.json", data: gradient)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "gradients", "attributes" => _gradient_params}}) do
    gradient = Repo.get!(Gradient, id)
    changeset = Gradient.changeset(gradient, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, gradient} ->
        render(conn, "show.json", data: gradient)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Colorstorm.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    gradient = Repo.get!(Gradient, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(gradient)

    send_resp(conn, :no_content, "")
  end

  defp create_permalink(title, id) do
    id_title_truncated = Integer.to_string(id) <> title
      |> String.slice(0,4)
      |> String.pad_trailing(5, "0")
      |> Base.hex_encode32(padding: false)
      |> String.downcase
  end

end
