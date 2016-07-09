defmodule Colorstorm.GradientLayerTest do
  use Colorstorm.ModelCase

  alias Colorstorm.GradientLayer

  @valid_attrs %{angle: "120.5", gradient_type: "some content", order: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GradientLayer.changeset(%GradientLayer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GradientLayer.changeset(%GradientLayer{}, @invalid_attrs)
    refute changeset.valid?
  end
end
