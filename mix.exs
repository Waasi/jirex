defmodule Jirex.Mixfile do
  use Mix.Project

  def project do
    [app: :jirex,
     version: "0.0.1",
     elixir: "~> 1.3",
     description: "A simple client for JIRA REST API",
     package: package,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison, :poison]]
  end

  defp deps do
    [{:httpoison, "~> 0.9.0"}, {:poison, "~> 3.0"}, {:ex_doc, ">= 0.0.0", only: :dev}]
  end

  def package do
    [ name: :jirex,
      files: ["lib", "mix.exs"],
      maintainers: ["Eric Santos"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/Waasi/jirex"}
    ]
  end
end
