defmodule Colorstorm.Redis do
  # use Supervisor
  require Logger

  @reconnect_after_ms 5_000
  @redix_opts [:host, :port, :password, :database]

  # def start_link do
  #   Supervisor.start_link(__MODULE__, [])
  # end

  def initialize do
    state = %{connection_options: [
        host: "localhost",
        port: 6379,
        password: "password",
        database: 0
      ],
      id: nil,
      name: nil,
      redix_pid: nil,
      reconnect_timer: nil
    }

    pool_size = 5
    redix_workers = for i <- 0..(pool_size - 1) do
      name = :"redix_#{i}"
      establish_connection(%{state | name: name, id: {Redix, i}})
      # worker(Redix, [[], [name: state.name]], id: {Redix, i})
    end

    # supervise(redix_workers, strategy: :one_for_one)
  end

  defp establish_success(state) do
    Logger.info "Successfully connected to redis for pid #{state.name}"
    state
  end

  defp establish_failed(state) do
    Logger.error "unable to establish initial redis connection. Attempting to reconnect..."
    %{state | redix_pid: nil,
              reconnect_timer: schedule_reconnect(state)}
  end

  defp schedule_reconnect(state) do
    if state.reconnect_timer, do: :timer.cancel(state.reconnect_timer)
    {:ok, timer} = :timer.send_after(@reconnect_after_ms, :establish_connection)

    timer
  end

  defp establish_connection(state) do
    redix_options = Keyword.take(state.connection_options, @redix_opts)

    case Redix.start_link(redix_options, [name: state.name, sync_connect: true]) do
      {:ok, redix_pid} -> establish_success(%{state | redix_pid: redix_pid})
      {:error, _} ->
        establish_failed(state)
    end
  end

  def command(command) do
    Redix.command(:"redix_#{random_index()}", command)
  end

  def command(command, options) do
    Redix.command(:"redix_#{random_index()}", command, options)
  end

  defp random_index() do
    rem(System.unique_integer([:positive]), 5)
  end
end