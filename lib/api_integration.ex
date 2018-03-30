defmodule Imlazy.ApiIntegration do
  alias Imlazy.{Tvshowtime, Rarbg}

  @download_folder Application.get_env(:imlazy, :download_folder)

  def to_watch() do
    case Tvshowtime.get("/to_watch") do
      {:ok, %HTTPoison.Response{body: body}} ->
        Poison.decode!(body, keys: :atoms).episodes

      _ ->
        nil
    end
  end

  def episode(episode_id) do
    case Tvshowtime.get("/episode?episode_id=#{episode_id}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body, keys: :atoms).episode

      _ ->
        nil
    end
  end

  def show(show_id) do
    case Tvshowtime.get("/show?show_id=#{show_id}") do
      {:ok, %HTTPoison.Response{body: body}} ->
        Poison.decode!(body, keys: :atoms).show

      _ ->
        nil
    end
  end

  def get_magnet_url(episode, token) do
    number = "S#{prepend_zero(episode.season_number)}E#{prepend_zero(episode.number)}"
    full_name = "#{dotify(episode.show.name)}.#{number}"
    {found, 0} = System.cmd("find", ["-iname", "#{full_name}*"], cd: @download_folder)

    if found == "" do
      :timer.sleep(2000)

      case Rarbg.get(
             "&sort=seeders&mode=search&search_tvdb=#{episode.show.id}&token=#{token}&search_string=#{
               number
             }"
           ) do
        {:ok, %HTTPoison.Response{body: body}} ->
          case Poison.decode(body, keys: :atoms) do
            {:ok, result} ->
              {:ok, get_best_torrent(result[:torrent_results])[:download]}

            _ ->
              nil
          end

        _ ->
          nil
      end
    end
  end

  def prepend_zero(number) do
    String.pad_leading(to_string(number), 2, "0")
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
      # length(grouped["1080p"] || []) > 0 -> List.first(grouped["1080p"])
      length(grouped["720p"] || []) > 0 ->
        List.first(grouped["720p"])

      true ->
        List.first(grouped["HD"] || [])
    end
  end

  def dotify(string) do
    String.replace(string, " ", ".")
    |> String.replace(~r/[^A-Za-z0-9.]/, "")
  end
end
