defmodule ElixtronDesktop.MixProject do
  use Mix.Project

  @app :elixtron_desktop

  def project do
    [
      app: @app,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ElixtronDesktop.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bakeware, "~>0.2.0"},
      {:chrome_remote_interface, "~> 0.4.1"},
      {:singleton, "~> 1.0.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
  defp releases do
    [
      overwrite: true,
      demo: [ steps: [:assemble, &Bakeware.assemble/1] ]
    ]
  end
end
