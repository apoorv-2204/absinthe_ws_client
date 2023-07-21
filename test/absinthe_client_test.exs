defmodule AbsintheClientTest do
  @moduledoc false
  alias AbsintheClient
  use ExUnit.Case

  describe "AbsintheClient" do
    # test "sdas" do
    #     {:ok,pid}= AbsintheClient.spawn("ws://localhost:4000/socket/websocket")
    #   AbsintheClient.request_server(
    #     pid,
    #     "subscription{   oracleUpdate{services{ uco {  eur  usd}}}  } "
    #   )

    #   receive do
    #     %{
    #       "oracleUpdate" => %{
    #         "services" => %{"uco" => %{"eur" => _, "usd" => _}}
    #       }
    #     } ->
    #       assert true
    #   end
    # end
  end
end
