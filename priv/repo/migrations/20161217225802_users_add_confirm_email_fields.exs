defmodule Colorstorm.Repo.Migrations.UsersAddConfirmEmailFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email_address_confirmed, :boolean, default: false
    end
  end
end
