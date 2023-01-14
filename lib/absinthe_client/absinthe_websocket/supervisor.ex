defmodule AbsintheWebSocketClient.Supervisor do
  @module false

  use Supervisor
  alias AbsintheWebSocketClient.SubscriptionProcess
  alias AbsintheWebSocketClient.WebSocketProcess

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(args) do
    children = [
      {SubscriptionProcess, args},
      {DynamicSupervisor,
       [strategy: :one_for_one, name: AbsintheWebSocketClient.WebSocketSupervisor]}
    ]

    Supervisor.start_child(children, strategy: :one_for_all)
  end
end
