defmodule Imlazy.Web.PageController do
  use Imlazy.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
