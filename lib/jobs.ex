defmodule Imlazy.Jobs do
  alias Imlazy.ApiIntegration, as: Api

  def add_new_episodes(date \\ nil) do
    for episode <- Api.to_watch() do
      [year, month, day] = String.split(episode.air_date, "-")
      |> Enum.map(fn(x)-> String.to_integer(x) end)

      {:ok, air_date} = Date.new(year, month, day)
      today = Date.utc_today()
      {:ok, yesterday} = Date.new(today.year, today.month, today.day - 1)
      date = date || yesterday

      if air_date >= date do
        episode_details = Api.episode(episode.id)

        cond do
          episode_details.seen == false && !episode_details.network in ["Netflix", "Amazon"] ->
            case Api.get_magnet_url(episode_details) do
              nil -> nil
              magnet ->
                System.cmd("transmission-gtk", [])
                System.cmd("transmission-remote-cli", [magnet])
            end
          true -> nil
        end
      end
    end
  end
end
