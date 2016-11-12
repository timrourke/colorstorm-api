defmodule Colorstorm.GradientLayerControllerTest do
  use Colorstorm.ConnCase

  alias Colorstorm.GradientLayer
  alias Colorstorm.Repo

  @valid_attrs %{angle: "120.5", gradient_type: "some content", order: 42}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do 
    gradient = Repo.insert!(%Colorstorm.Gradient{})

    %{
      "gradient" => %{
        "data" => %{
          "type" => "gradient",
          "id" => gradient.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, gradient_layer_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    gradient_layer = Repo.insert! %GradientLayer{}
    conn = get conn, gradient_layer_path(conn, :show, gradient_layer)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{gradient_layer.id}"
    assert data["type"] == "gradient_layer"
    assert data["attributes"]["angle"] == gradient_layer.angle
    assert data["attributes"]["order"] == gradient_layer.order
    assert data["attributes"]["gradient_type"] == gradient_layer.gradient_type
    assert data["attributes"]["gradient_id"] == gradient_layer.gradient_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, gradient_layer_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, gradient_layer_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "gradient_layer",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(GradientLayer, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, gradient_layer_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "gradient_layer",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    gradient_layer = Repo.insert! %GradientLayer{}
    conn = put conn, gradient_layer_path(conn, :update, gradient_layer), %{
      "meta" => %{},
      "data" => %{
        "type" => "gradient_layer",
        "id" => gradient_layer.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(GradientLayer, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    gradient_layer = Repo.insert! %GradientLayer{}
    conn = put conn, gradient_layer_path(conn, :update, gradient_layer), %{
      "meta" => %{},
      "data" => %{
        "type" => "gradient_layer",
        "id" => gradient_layer.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    gradient_layer = Repo.insert! %GradientLayer{}
    conn = delete conn, gradient_layer_path(conn, :delete, gradient_layer)
    assert response(conn, 204)
    refute Repo.get(GradientLayer, gradient_layer.id)
  end

end
