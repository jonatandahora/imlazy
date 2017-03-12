defmodule Imlazy.Api.Access do
  use Ecto.Schema
  
  schema "api_access" do
    field :device_code, :string
    field :user_code, :string
    field :access_token, :string

    timestamps()
  end
end
