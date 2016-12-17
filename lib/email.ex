defmodule Colorstorm.Email do
  use Bamboo.Phoenix, view: Colorstorm.EmailView

  def welcome_text_email(email_assigns) do
    new_email
    |> to(email_assigns["user"].email)
    |> from("tim@timrourke.com")
    |> subject("Welcome to ColorStorm!")
    |> put_text_layout({Colorstorm.LayoutView, "email.text"})
    |> render("welcome.text", email_assigns: email_assigns)
  end

  def welcome_html_email(email_assigns) do
    email_assigns
    |> welcome_text_email()
    |> put_html_layout({Colorstorm.LayoutView, "email.html"})
    |> render("welcome.html", email_assigns: email_assigns)
  end
end