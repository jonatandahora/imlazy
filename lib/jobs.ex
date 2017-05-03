defmodule Imlazy.Jobs do
  alias Imlazy.ApiIntegration, as: Api

  @download_folder Application.get_env(:imlazy, :download_folder)
  @watched_folder System.user_home()

  def add_new_episodes(date \\ nil) do
    magnets = for episode <- Api.to_watch() do
      [year, month, day] = String.split(episode.air_date, "-")
      |> Enum.map(fn(x)-> String.to_integer(x) end)

      air_date = Timex.to_date({year, month, day})
      today = Timex.now() |> Timex.to_date()
      yesterday = Timex.shift(today, days: -1)
      date = date || yesterday
      if air_date >= date do
        episode_details = Api.episode(episode.id)

        cond do
          episode_details.seen == false && !episode_details.network in ["Netflix", "Amazon"] ->
            case Api.get_magnet_url(episode_details) do
              {_, nil} -> nil
              {name, magnet} ->
                {found, 0} = System.cmd("find", ["-iname", "#{name}*"], [cd: @download_folder])
                unless found != "", do: magnet
            end
          true -> nil
        end
      end
    end
    |> Enum.filter(&(&1 != nil))

    if length(magnets) > 0 do
      File.write("#{@watched_folder}/imlazy.magnet", Enum.join(magnets, "\n"))
    end
  end
end
