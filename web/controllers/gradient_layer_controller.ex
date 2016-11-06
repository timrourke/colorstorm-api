defmodule Colorstorm.GradientLayerController do
  use Colorstorm.Web, :controller
  import Ecto.Query, only: [from: 2]
  alias Colorstorm.GradientLayer
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  @relationships ["gradient", "gradient_stops"]

  def index(conn, %{"gradient_id" => gradient_id, "include" => include}) do
    rel_string = String.replace(include, "-", "_")

    gradientLayers = 
      rel_string
      |> String.split(",")
      |> Enum.filter(fn value -> value in @relationships end)
      |> always_preload_gradient_stops
      |> Enum.map(fn value -> String.to_atom(value) end)
      |> gradient_layer_query
      |> Ecto.Query.where(gradient_id: ^gradient_id)
      |> Repo.all

    render(conn, "index.json", 
      data: gradientLayers, 
      opts: [include: rel_string])
  end

  def index(conn, %{"gradient_id" => gradient_id}) do
    query = from gl in GradientLayer,
      where: gl.gradient_id == ^gradient_id
    gradient_layers = Repo.all(query)

    render(conn, "index.json", data: gradient_layers)
  end

  def index(conn, %{"include" => include}) when include != "" do
    rel_string = String.replace(include, "-", "_")

    gradientLayers = 
      rel_string
      |> String.split(",")
      |> Enum.filter(fn value -> value in @relationships end)
      |> Enum.map(fn value -> String.to_atom(value) end)
      |> gradient_layer_query
      |> Repo.all

    render(conn, "index.json", 
      data: gradientLayers, 
      opts: [include: rel_string])
  end

  def index(conn, _params) do
    gradient_layers = Repo.all(GradientLayer)
    render(conn, "index.json", data: gradient_layers)
  end

  defp gradient_layer_query(value) do 
    from gl in GradientLayer, preload: [^value]
  end

  defp always_preload_gradient_stops(includes) do
    if !Enum.member?(includes, "gradient_stops") do
      includes = Enum.concat(includes, ["gradient_stops"])
    end

    includes
  end

  def create(conn, %{"data" => data = %{"type" => "gradient-layers", "attributes" => _gradient_layer_params}}) do
    changeset = GradientLayer.changeset(%GradientLayer{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, gradient_layer} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", gradient_layer_path(conn, :show, gradient_layer))
        |> render("show.json", data: gradient_layer)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Colorstorm.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    gradient_layer = Repo.get!(GradientLayer, id)
    render(conn, "show.json", data: gradient_layer)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "gradient-layers", "attributes" => _gradient_layer_params}}) do
    gradient_layer = Repo.get!(GradientLayer, id)
    changeset = GradientLayer.changeset(gradient_layer, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, gradient_layer} ->
        render(conn, "show.json", data: gradient_layer)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Colorstorm.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    gradient_layer = Repo.get!(GradientLayer, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(gradient_layer)

    send_resp(conn, :no_content, "")
  end

end
