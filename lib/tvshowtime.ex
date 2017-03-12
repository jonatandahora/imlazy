defmodule Imlazy.Tvshowtime do
  use HTTPoison.Base
  alias Imlazy.Api

  @config Application.get_env(:imlazy, :tvshowtime)

  def process_url(url) do
    @config[:api_url] <> url
  end

  def process_request_headers(headers) do
    access = List.first(Api.list_access())
    [{"TVST_ACCESS_TOKEN", access.access_token}] ++ headers
  end
end
