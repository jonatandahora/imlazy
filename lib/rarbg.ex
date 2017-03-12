defmodule Imlazy.Rarbg do
  use HTTPoison.Base

  @config Application.get_env(:imlazy, :rarbg)

  def process_url(url) do
    @config[:api_url] <> url
  end
end
