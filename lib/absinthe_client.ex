defmodule AbsintheClient do
  @moduledoc """
    GQL ABsinthe Subscription Abstraction provider.s
  """
  alias AbsintheClient.Supervisor
  alias AbsintheClient.SocketHandler

  def create_client(opts) when is_list(opts), do: Supervisor.start_link(opts)
  def create_client(websocket_url), do: Supervisor.start_link(ws_url: websocket_url)

  def subscribe(
        query,
        var,
        random_id \\ :crypto.strong_rand_bytes(12) |> Base.url_encode64()
      ) do
    SocketHandler.subscribe(SocketHandler, self(), random_id, query, var)
  end

  # @doc """
  #   Create a new Websocket client Genserver. It will communicate with Absinthe (Subscription or query) Server based on Elxir Absinthe.
  # """
  # @spec spawn(opts::list()) :: Process.on_start()
  # def spawn(opts) when is_list(opts), do: SocketHandler.start_link(opts)

  @spec spawn(websocket_url :: String.t()) :: Process.on_start()
  def spawn(websocket_url), do: SocketHandler.start_link(ws_url: websocket_url)

  # {:ok,pid}= AbsintheClient.request_server(pid, "subscription{   oracleUpdate{services{ uco {  eur  usd}}}  } ")
  def request_server(
        pid,
        query,
        rand_sub_id \\ :crypto.strong_rand_bytes(12) |> Base.url_encode64()
      ) do
    SocketHandler.subscribe(pid, self(), rand_sub_id, query, %{})
  end

  # @spec spawn(host :: String.t(), port :: String.t()) ::
  #         Process.on_start()
  # def spawn(host, port), do: SocketHandler.start_link(host: host, port: port)
end
