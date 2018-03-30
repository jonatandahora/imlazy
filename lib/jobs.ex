defmodule Imlazy.Jobs do
  alias Imlazy.ApiIntegration, as: Api
  alias Imlazy.Rarbg

  @watched_folder System.user_home()

  def add_new_episodes() do
    token =
      case Rarbg.get("&get_token=get_token") do
        {:ok, %HTTPoison.Response{body: body}} ->
          Poison.decode!(body, keys: :atoms).token

        _ ->
          nil
      end

    ParallelStream.map(Api.to_watch(), fn episode ->
      episode_details = Api.episode(episode.id)

      cond do
        episode_details == nil ->
          nil

        episode_details.seen == false && !(episode_details.network in ["Netflix", "Amazon"]) ->
          case Api.get_magnet_url(episode_details, token) do
            {:ok, magnet} -> magnet
            _ -> nil
          end

        true ->
          nil
      end
    end)
    |> write_to_file()
  end

  def write_to_file(magnets) do
    magnets =
      Enum.into(magnets, [])
      |> Enum.filter(&(&1 != nil))

    if length(magnets) > 0 do
      File.write("#{@watched_folder}/imlazy.magnet", Enum.join(magnets, "\n"))
    end
  end
end
