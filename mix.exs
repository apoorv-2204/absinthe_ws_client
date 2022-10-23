defmodule AbsintheWebSocketClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :absinthe_webSocket_client,
      version: "0.1.0",
      elixir: "~> 1.12.3",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.0"},
      {:websockex, "~> 0.4.3"}
    ]
  end
end
