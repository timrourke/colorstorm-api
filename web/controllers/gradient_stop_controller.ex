defmodule Colorstorm.GradientStopController do
  use Colorstorm.Web, :controller

  alias Colorstorm.GradientStop
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  @relationships ["gradient_layer"]

  def index(conn, %{"gradient_layer_id" => gradient_layer_id}) do
    query = from gs in GradientStop,
      where: gs.gradient_layer_id == ^gradient_layer_id
    gradient_stops = Repo.all(query)

    render(conn, "index.json", data: gradient_stops)
  end

  def index(conn, %{"include" => include}) when include != "" do
    rel_string = String.replace(include, "-", "_")

    gradientStops = 
      rel_string
      |> String.split(",")
      |> Enum.filter(fn value -> value in @relationships end)
      |> Enum.map(fn value -> String.to_atom(value) end)
      |> gradient_stop_query
      |> Repo.all

    render(conn, "index.json", 
      data: gradientStops, 
      opts: [include: rel_string])
  end

  def index(conn, _params) do
    gradient_stops = Repo.all(GradientStop)
    render(conn, "index.json", data: gradient_stops)
  end

  defp gradient_stop_query(value) do 
    from gs in GradientStop, preload: [^value]
  end

  def create(conn, %{"data" => data = %{"type" => "gradient-stops", "attributes" => _gradient_stop_params}}) do
    changeset = GradientStop.changeset(%GradientStop{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, gradient_stop} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", gradient_stop_path(conn, :show, gradient_stop))
        |> render("show.json", data: gradient_stop)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Colorstorm.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    gradient_stop = Repo.get!(GradientStop, id)
    render(conn, "show.json", data: gradient_stop)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "gradient-stops", "attributes" => _gradient_stop_params}}) do
    gradient_stop = Repo.get!(GradientStop, id)
    changeset = GradientStop.changeset(gradient_stop, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, gradient_stop} ->
        render(conn, "show.json", data: gradient_stop)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Colorstorm.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    gradient_stop = Repo.get!(GradientStop, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(gradient_stop)

    send_resp(conn, :no_content, "")
  end

end
