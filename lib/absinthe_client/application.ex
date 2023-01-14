defmodule AbsintheClient.Application do
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Registry, keys: :duplicate, name: AbsintheClient.PubSubRegistry}
    ]

    opts = [strategy: :rest_for_one, name: AbsintheClient.Supervisor]
    Supervisor.start_link(Utils.configurable_children(children), opts)
  end
end
