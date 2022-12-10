defmodule AbsintheWebSocket.Handler do
  @moduledoc """
   Genserver with WebSockex to handle websocket (for absinthe subscription)
  """
  use WebSockex
  require Logger

  @heartbeat_sleep 15_000
  @disconnect_sleep 15_000

  @soec start_link(list.t()) :: GenServer.start()
  def start_link(opts \\ []) do
    host = Keyword.fetch!(opts, :host)
    port = Keyword.get!(opts, :port)

    ws_url =
      if Keyword.get(opts, :secure) do
        "wss://#{host}:#{port}/socket/websocket"
      else
        "ws://#{host}:#{port}/socket/websocket"
      end

    state = %{
      subscriptions: %{},
      queries: %{},
      msg_ref: 0,
      heartbeat_timer: nil
    }

    WebSockex.start_link(ws_url, __MODULE__, state,
      handle_initial_conn_failure: true,
      async: true
    )
  end

  # use of macro websockex
  # def init(args) do
  #   {:ok, args}
  # end

  # webosockex impl
  def handle_connect(_conn, state) do
    WebSockex.cast(self(), :join)

    # Send a heartbeat
    heartbeat_timer = Process.send_after(self(), :heartbeat, @heartbeat_sleep)
    state = Map.put(state, :heartbeat_timer, heartbeat_timer)

    {:ok, state}
  end

  def handle_cast(:join, state = %{msg_ref: msg_ref}) do
    msg =
      %{
        topic: "__absinthe__:control",
        event: "phx_join",
        payload: %{},
        ref: msg_ref
      }
      |> Jason.encode!()

    new_state =
      state
      |> Map.update!(:queries, &Map.put(&1, msg_ref, :join))
      |> Map.update!(:msg_ref, &(&1 + 1))

    {:reply, {:text, msg}, new_state}
  end

  def handle_disconnect(map, state = %{heartbeat_timer: heartbeat_timer}) do
    if state.log_disconnect do
      Logger.error("#{__MODULE__} - Disconnected: #{inspect(map)}")
    end

    if heartbeat_timer do
      :timer.cancel(heartbeat_timer)
    end

    state = Map.put(state, :heartbeat_timer, nil)

    if state.disconnect_callback do
      state.disconnect_callback.()
    end

    :timer.sleep(@disconnect_sleep)

    {:reconnect, %{state | ready: false}}
  end

  @impl WebSockex
  def handle_info(:heartbeat, state) do
    WebSockex.cast(self(), :heartbeat)

    # Send another heartbeat
    heartbeat_timer = Process.send_after(self(), :heartbeat, @heartbeat_sleep)
    state = Map.put(state, :heartbeat_timer, heartbeat_timer)

    {:ok, state}
  end

  def handle_cast(:heartbeat, state = %{msg_ref: msg_ref}) do
    msg =
      %{
        topic: "phoenix",
        event: "heartbeat",
        payload: %{},
        ref: msg_ref
      }
      |> Jason.encode!()

    new_state =
      state
      |> Map.update!(:queries, &Map.put(&1, msg_ref, :hearbeat))
      |> Map.update!(:msg_ref, &(&1 + 1))

    {:reply, {:text, msg}, new_state}
  end

  def handle_info(msg, state) do
    Logger.info("#{__MODULE__} Info - Message: #{inspect(msg)}")

    {:ok, state}
  end

  def query(socket_pid, client_pid, ref, query, variables \\ []) do
    WebSockex.cast(socket_pid, {:query, {client_pid, ref, query, variables}})
  end

  def subscribe(socket_pid, client_pid, id, query, variables \\ []) do
    WebSockex.cast(
      socket_pid,
      {:subscribe, {client_pid, id, query, variables}}
    )
  end

  def handle_cast(
        {:query, {pid, ref, query, variables}},
        %{queries: queries, msg_ref: msg_ref} = state
      ) do
    doc = %{
      "query" => query,
      "variables" => variables
    }

    msg =
      %{
        topic: "__absinthe__:control",
        event: "doc",
        payload: doc,
        ref: msg_ref
      }
      |> Poison.encode!()

    queries = Map.put(queries, msg_ref, {:query, pid, ref})

    state =
      state
      |> Map.put(:queries, queries)
      |> Map.put(:msg_ref, msg_ref + 1)

    {:reply, {:text, msg}, state}
  end
end
