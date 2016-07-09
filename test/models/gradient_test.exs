defmodule Colorstorm.GradientTest do
  use Colorstorm.ModelCase

  alias Colorstorm.Gradient

  @valid_attrs %{body: "some content", body_autoprefixed: "some content", description: "some content", permalink: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Gradient.changeset(%Gradient{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Gradient.changeset(%Gradient{}, @invalid_attrs)
    refute changeset.valid?
  end
end
