defmodule Colorstorm.GradientStopTest do
  use Colorstorm.ModelCase

  alias Colorstorm.GradientStop

  @valid_attrs %{color: "some content", left: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GradientStop.changeset(%GradientStop{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GradientStop.changeset(%GradientStop{}, @invalid_attrs)
    refute changeset.valid?
  end
end
