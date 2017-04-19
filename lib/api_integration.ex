defmodule Imlazy.ApiIntegration do
  alias Imlazy.{Tvshowtime, Rarbg}

  def to_watch() do
    case Tvshowtime.get("/to_watch") do
      {:ok, %HTTPoison.Response{body: body}} ->
        Poison.decode!(body, [keys: :atoms]).episodes
      _ -> nil
    end
  end

  def episode(episode_id) do
    case Tvshowtime.get("/episode?episode_id=#{episode_id}") do
      {:ok, %HTTPoison.Response{body: body}} ->
        Poison.decode!(body, [keys: :atoms]).episode
      _ -> nil
    end
  end

  def get_magnet_url(episode) do
    :timer.sleep(2000)
    full_name = "#{dotify(episode.show.name)}.S#{prepend_zero(episode.season_number)}E#{prepend_zero(episode.number)}"
    number = "S#{prepend_zero(episode.season_number)}E#{prepend_zero(episode.number)}"

    case Rarbg.get("?get_token=get_token") do
      {:ok, %HTTPoison.Response{body: body}} ->
        :timer.sleep(2000)
        token = Poison.decode!(body, [keys: :atoms]).token

        case Rarbg.get("?sort=seeders&mode=search&search_tvdb=#{episode.show.id}&token=#{token}&search_string=#{number}") do
          {:ok, %HTTPoison.Response{body: body}} ->
            torrents = Poison.decode!(body, [keys: :atoms])[:torrent_results]
            {full_name, get_best_torrent(torrents)[:download]}
          _ -> nil
        end
      _ -> nil
    end
  end

  def prepend_zero(number) do
    String.rjust(to_string(number), 2, ?0)
  end

  def get_torrent_quality(torrent) do
    cond do
      String.contains?(torrent.filename, "720p") -> "720p"
      String.contains?(torrent.filename, "1080p") -> "1080p"
      true -> "HD"
    end
  end

  def get_best_torrent([]), do: nil
  def get_best_torrent(nil), do: nil
  def get_best_torrent(torrents) do
    grouped = Enum.group_by(torrents, &get_torrent_quality/1)
    cond do
      length(grouped["1080p"] || []) > 0 -> List.first(grouped["1080p"])
      length(grouped["720p"] || []) > 0 -> List.first(grouped["720p"])
      true ->  List.first(grouped["HD"] || [])
    end
  end

  def dotify(string) do
    String.replace(string, " ", ".")
    |> String.replace("'", "")
  end
end
