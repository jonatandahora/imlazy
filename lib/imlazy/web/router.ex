defmodule Imlazy.Web.Router do
  use Imlazy.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Imlazy.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/auth", AuthController, :index
    get "/auth/validate", AuthController, :validate
  end

  # Other scopes may use custom stacks.
  # scope "/api", Imlazy.Web do
  #   pipe_through :api
  # end
end
