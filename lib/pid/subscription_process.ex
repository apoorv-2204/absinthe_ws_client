defmodule ArchEthic.Utils.WebSocket.SubscriptionProcess do
  @moduledoc "
    Genserver that handles subscription logic.
  "
  use GenServer
  require Logger
  alias ArchEthic.Utils.WebSocket.WSProcess

  def start_link(opts) do
    name = Keyword.get(opts, :ss_name, __MODULE__)

    state = %{
      socket: WSProcess.start(opts),
      subscriptions: %{}
    }

    GenServer.start_link(__MODULE__, state, name: name)
  end

  def start(opts) do
    name = Keyword.get(opts, :ss_name, __MODULE__)

    state = %{
      socket: WSProcess.start_link(opts)|>elem(1),
      subscriptions: %{}
    }

    GenServer.start(__MODULE__, state, name: name)
  end

  def init(state) do
    {:ok, state}
  end

  def set_state(pid, ws_pid) do
    GenServer.cast(
      pid,
      {:set_state, ws_pid}
    )
  end

  def handle_cast({:set_state, ws_pid}, state) do
    {:noreply, %{state | socket: ws_pid}}
  end

  def subscribe(pid, local_subscription_id, callback_or_dest, query, variables \\ []) do
    IO.inspect(pid, label: "ubscribe(pid")
    GenServer.cast(
      pid,
      {:subscribe, local_subscription_id, callback_or_dest, query, variables}
    )
  end

  def handle_cast(
        {:subscribe, local_subscription_id, callback_or_dest, query, variables},
        state = %{socket: socket_pid, subscriptions: subscriptions}
      ) do
    WSProcess.subscribe(socket_pid, self(), local_subscription_id, query, variables)

    callbacks = Map.get(subscriptions, local_subscription_id, [])
    subscriptions = Map.put(subscriptions, local_subscription_id, [callback_or_dest | callbacks])
    state = Map.put(state, :subscriptions, subscriptions)

    {:noreply, state}
  end

  # Incoming Notifications (from WSClient.WSProcess)
  def handle_cast(
        {:subscription, local_subscription_id, response},
        state = %{subscriptions: subscriptions}
      ) do
    subscriptions
    |> Map.get(local_subscription_id, [])
    |> Enum.each(fn callback_or_dest -> handle_callback_or_dest(callback_or_dest, response) end)

    {:noreply, state}
  end

  def handle_cast({:joined}, state) do
    {:noreply, state}
  end

  defp handle_callback_or_dest(callback_or_dest, response) do
    if is_function(callback_or_dest) do
      callback_or_dest.(response)
    else
      send(callback_or_dest, response)
    end
  end
end
