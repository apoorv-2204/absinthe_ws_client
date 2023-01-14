defmodule AbsintheWebSocketClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :absinthe_client,
      version: "0.1.1",
      elixir: "~> 1.14.1",
      build_path: "_build",
      config_path: "config/config.exs",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: dialyzer()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:mix, :ex_unit],
      plt_core_path: "priv/plts",
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.0"},
      {:websockex, "~> 0.4.3"},
      {:sobelow, "~> 0.11", only: [:test, :dev], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      "dev.clean": ["cmd make clean", "clean", "format", "compile"],
      "dev.checks": [
        "clean",
        "format",
        "compile",
        " hex.outdated --within-requirements",
        "credo",
        "sobelow",
        "cmd mix test --trace",
        "dialyzer"
      ]
    ]
  end
end
