# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :imlazy,
  ecto_repos: [Imlazy.Repo],
  download_folder: "/mnt/Dados/Séries"

# Configures the endpoint
config :imlazy, Imlazy.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zcSrZNvJgh6pJf2Bi7I+6EXBmwKUxpmmTcBLhrq64pVqJepN7ENy+AaUQRDPnaje",
  render_errors: [view: Imlazy.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Imlazy.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :imlazy, :rarbg, api_url: "https://torrentapi.org/pubapi_v2.php?app_id=imlazy"

config :imlazy, :tvshowtime,
  verification_url: "https://tvtime.com/activate",
  api_url: "https://api.tvtime.com/v1",
  access_token_url: "https://api.tvtime.com/v1/oauth/access_token",
  device_code_url: "https://api.tvtime.com/v1/oauth/device/code",
  client_id: "iM2Vxlwr93imH7nwrTEZ",
  client_secret: "ghmK6ueMJjQLHBwsaao1tw3HUF7JVp_GQTwDwhCn"

config :imlazy, Imlazy.Scheduler,
  timezone: "America/Sao_Paulo",
  jobs: [
    {"0 3 * * *", {Imlazy.Jobs, :add_new_episodes, []}}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
