defmodule Colorstorm.Gradient do
  use Colorstorm.Web, :model

  schema "gradients" do
    field :body, :string
    field :body_autoprefixed, :string
    field :description, :string
    field :permalink, :string
    field :title, :string
    belongs_to :user, Colorstorm.User

    timestamps
  end

  @required_fields ~w(body body_autoprefixed description permalink title user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
