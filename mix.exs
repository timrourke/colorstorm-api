defmodule Colorstorm.Mixfile do
  use Mix.Project

  def project do
    [app: :colorstorm,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Colorstorm, []},
      applications: [
        :bamboo,
        :bamboo_smtp,
        :comeonin,
        :cors_plug,
        :cowboy,
        :exrm,
        :gettext,
        :guardian,
        :ja_serializer,
        :logger_file_backend,
        :phoenix,
        :phoenix_html,
        :phoenix_ecto,
        :phoenix_pubsub,
        :postgrex,
        :redix
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bamboo, "~> 0.7"},
      {:bamboo_smtp, "~> 1.2.1"},
      {:comeonin, "~> 2.5"},
      {:cors_plug, "~> 1.1"},
      {:cowboy, "~> 1.0"},
      {:exrm, "~> 0.15.3"},
      {:gettext, "~> 0.9"},
      {:guardian, "~> 0.13.0"},
      {:ja_serializer, "~> 0.11.0"},
      {:logger_file_backend, "0.0.9"},
      {:phoenix, "~> 1.2.1"},
      {:phoenix_ecto, "~> 3.0-rc"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_pubsub, "~> 1.0"},
      {:postgrex, ">= 0.12.1"},
      {:redix, "~> 0.4.0"}
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": [
          "ecto.create", 
          "ecto.migrate", 
          "run priv/repo/seeds.exs"
      ],
      "ecto.reset": [
        "ecto.drop",
        "ecto.setup"
      ],
      "test": [
        "ecto.create --quiet", 
        "ecto.migrate", 
        "test"
      ]
    ]
  end
end
