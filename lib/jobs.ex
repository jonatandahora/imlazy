defmodule Imlazy.Jobs do
  alias Imlazy.ApiIntegration, as: Api

  @download_folder Application.get_env(:imlazy, :download_folder)

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
              {_, nil} -> nil
              {name, magnet} ->
                {found, 0} = System.cmd("find", ["-iname", "#{name}*"], [cd: @download_folder])

                unless found != "" do
                  System.cmd("transmission-daemon", [])
                  System.cmd("transmission-remote-cli", [magnet])
                  "Added: #{name}"
                end
            end
          true -> nil
        end
      end
    end
  end
end
