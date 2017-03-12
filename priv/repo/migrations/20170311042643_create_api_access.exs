defmodule Imlazy.Repo.Migrations.CreateImlazy.Api.Access do
  use Ecto.Migration

  def change do
    create table(:api_access) do
      add :device_code, :string
      add :user_code, :string
      add :access_token, :string

      timestamps()
    end

  end
end
