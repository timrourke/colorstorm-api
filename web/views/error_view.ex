defmodule Colorstorm.ErrorView do
  use Colorstorm.Web, :view

  def render("404.json", _assigns) do
    %{errors: %{detail: "Page not found"}}
  end

  def render("404.json-api", _assigns) do
    %{errors: %{detail: "Page not found"}}
      |> JaSerializer.ErrorSerializer.format
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Server internal error"}}
  end

  def render("500.json-api", _assigns) do
    %{errors: %{detail: "Server internal error"}}
      |> JaSerializer.ErrorSerializer.format
  end

  def template_not_found(_template, assigns) do
    render "404.json", assigns
  end
end
