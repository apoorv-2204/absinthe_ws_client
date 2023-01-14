defmodule AbsintheClient.Utils.WebSocket.Client do
  @moduledoc """
    GQL ABsinthe Subscription Abstraction provider.
  """
  alias AbsintheClient.Utils.WebSocket.Supervisor
  alias AbsintheClient.Utils.WebSocket.SocketHandler

  def start_link(opts) do
    Supervisor.start_link(opts)
  end

  def absinthe_sub(query, variables, sub_id) do
    SocketHandler.subscribe(SocketHandler, self(), sub_id, query, variables)
  end
end
