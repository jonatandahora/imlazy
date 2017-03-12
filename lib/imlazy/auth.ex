defmodule Imlazy.Auth do
  @config Application.get_env(:imlazy, :tvshowtime)

  def get_device_code do
    case HTTPoison.post(@config[:device_code_url], {:form, [client_id: @config[:client_id]]}) do
      {:ok, %HTTPoison.Response{body: body}} ->
        body = Poison.decode!(body)
        %{device_code: body["device_code"], user_code: body["user_code"]}
      _ -> nil
    end
  end

  def get_validation_url(codes) do
    "#{@config[:verification_url]}?device_code=#{codes.device_code}&user_code=#{codes.user_code}"
  end

  def get_access_token(device_code) do
    form = {:form, [client_id: @config[:client_id],
                    client_secret: @config[:client_secret],
                    code: device_code]}
                    
    case HTTPoison.post(@config[:access_token_url], form) do
      {:ok, %HTTPoison.Response{body: body}} ->
        body = Poison.decode!(body)
        body["access_token"]
      _ -> nil
    end
  end
end
