defmodule Colorstorm.GradientControllerTest do
  use Colorstorm.ConnCase

  alias Colorstorm.Gradient
  alias Colorstorm.Repo

  @valid_attrs %{body: "some content", body_autoprefixed: "some content", description: "some content", permalink: "some content", title: "some content"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do 
    user = Repo.insert!(%Colorstorm.User{})

    %{
      "user" => %{
        "data" => %{
          "type" => "users",
          "id" => user.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, gradient_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    gradient = Repo.insert! %Gradient{}
    conn = get conn, gradient_path(conn, :show, gradient)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{gradient.id}"
    assert data["type"] == "gradients"
    assert data["attributes"]["body"] == gradient.body
    assert data["attributes"]["body_autoprefixed"] == gradient.body_autoprefixed
    assert data["attributes"]["description"] == gradient.description
    assert data["attributes"]["permalink"] == gradient.permalink
    assert data["attributes"]["title"] == gradient.title
    assert data["attributes"]["user_id"] == gradient.user_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, gradient_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, gradient_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "gradients",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Gradient, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, gradient_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "gradients",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    gradient = Repo.insert! %Gradient{}
    conn = put conn, gradient_path(conn, :update, gradient), %{
      "meta" => %{},
      "data" => %{
        "type" => "gradients",
        "id" => gradient.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Gradient, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    gradient = Repo.insert! %Gradient{}
    conn = put conn, gradient_path(conn, :update, gradient), %{
      "meta" => %{},
      "data" => %{
        "type" => "gradients",
        "id" => gradient.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    gradient = Repo.insert! %Gradient{}
    conn = delete conn, gradient_path(conn, :delete, gradient)
    assert response(conn, 204)
    refute Repo.get(Gradient, gradient.id)
  end

end
