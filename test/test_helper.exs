ExUnit.start

# Mix.Task.run "ecto.create", ~w(-r Colorstorm.Repo --quiet)
# Mix.Task.run "ecto.migrate", ~w(-r Colorstorm.Repo --quiet)
# Ecto.Adapters.SQL.begin_test_transaction(Colorstorm.Repo)
Ecto.Adapters.SQL.Sandbox.mode(Colorstorm.Repo, :manual)

