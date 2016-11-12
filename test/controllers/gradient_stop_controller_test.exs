defmodule Colorstorm.GradientStopControllerTest do
  use Colorstorm.ConnCase

  alias Colorstorm.GradientStop
  alias Colorstorm.Repo

  @valid_attrs %{color: "some content", left: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do 
    gradient_layer = Repo.insert!(%Colorstorm.GradientLayer{})

    %{
      "gradient_layer" => %{
        "data" => %{
          "type" => "gradient_layer",
          "id" => gradient_layer.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, gradient_stop_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    gradient_stop = Repo.insert! %GradientStop{}
    conn = get conn, gradient_stop_path(conn, :show, gradient_stop)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{gradient_stop.id}"
    assert data["type"] == "gradient_stop"
    assert data["attributes"]["left"] == gradient_stop.left
    assert data["attributes"]["color"] == gradient_stop.color
    assert data["attributes"]["gradient_layer_id"] == gradient_stop.gradient_layer_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, gradient_stop_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, gradient_stop_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "gradient_stop",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(GradientStop, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, gradient_stop_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "gradient_stop",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    gradient_stop = Repo.insert! %GradientStop{}
    conn = put conn, gradient_stop_path(conn, :update, gradient_stop), %{
      "meta" => %{},
      "data" => %{
        "type" => "gradient_stop",
        "id" => gradient_stop.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(GradientStop, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    gradient_stop = Repo.insert! %GradientStop{}
    conn = put conn, gradient_stop_path(conn, :update, gradient_stop), %{
      "meta" => %{},
      "data" => %{
        "type" => "gradient_stop",
        "id" => gradient_stop.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    gradient_stop = Repo.insert! %GradientStop{}
    conn = delete conn, gradient_stop_path(conn, :delete, gradient_stop)
    assert response(conn, 204)
    refute Repo.get(GradientStop, gradient_stop.id)
  end

end
