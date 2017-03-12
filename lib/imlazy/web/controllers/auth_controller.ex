defmodule Imlazy.Web.AuthController do
  use Imlazy.Web, :controller
  alias Imlazy.{Auth, Api}

  def index(conn, _params) do
    render conn, "index.html"
  end

  def validate(conn, _params) do
    codes = Auth.get_device_code()
    url = Auth.get_validation_url(codes)

    Task.async(fn() ->
      :timer.sleep(10000)
      token = Auth.get_access_token(codes.device_code)
      params = Map.put(codes, :access_token, token)
      Api.delete_all_access
      Api.create_access(params)
    end)

    redirect conn, external: url
  end
end
