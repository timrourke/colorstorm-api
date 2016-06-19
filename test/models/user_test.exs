defmodule Colorstorm.UserTest do
  use Colorstorm.ModelCase

  alias Colorstorm.User

  @valid_attrs %{
    email: "test@emailaddress.com", 
    password: "3643@3!gBBDFs", 
    password_confirmation: "3643@3!gBBDFs", 
    username: "fakeguy12"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "mis-matched password_confirmation doesn't work" do
    changeset = User.changeset(%User{}, %{email: "joe@example.com",
      password: "1lh2bj1rjbk2",
      password_confirmation: "b1bk23jkn12"})
    refute changeset.valid?
  end

  test "missing password_confirmation doesn't work" do
    changeset = User.changeset(%User{}, %{email: "joe@example.com",
      password: "1lh2bj1rjbk2"})
    refute changeset.valid?
  end

  test "short password doesn't work" do
    changeset = User.changeset(%User{}, %{email: "joe@example.com",
      password: "1lh2d",
      password_confirmation: "1lh2d"})
    refute changeset.valid?
  end
end
