defmodule Imlazy.Tvshowtime do
  use HTTPoison.Base
  alias Imlazy.Api
  Application.ensure_all_started(:imlazy) 

  @config Application.get_env(:imlazy, :tvshowtime)
  @access List.first(Api.list_access())

  def process_url(url) do
    @config[:api_url] <> url
  end

  def process_request_headers(headers) do
    [{"TVST_ACCESS_TOKEN", @access.access_token}] ++ headers
  end
end
