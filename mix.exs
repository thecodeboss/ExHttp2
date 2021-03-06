defmodule ExHttp2.Mixfile do
  use Mix.Project

  def project do
    [app: :exhttp2,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     test_coverage: [tool: ExCoveralls]]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    config = Mix.Config.read!("config/config.exs")
    [applications: [:logger],
     mod: {ExHttp2, config[:exhttp2]}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:timex, "~> 0.14.3"},
     {:excoveralls, "~> 0.3", only: [:dev, :test]}]
  end
end
