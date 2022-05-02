defmodule AbsintheWsClientTest do
  use ExUnit.Case
  doctest AbsintheWsClient

  test "greets the world" do
    assert AbsintheWsClient.hello() == :world
  end
end
