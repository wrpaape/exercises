defmodule Chain do
  @moduledoc """
  Module implementing multiple processes.
  """
  def counter(next_pid) do
    receive do
      n -> send next_pid, n + 1
    end
  end

  def create_processes(n) do
    last = Enum.reduce(1..n, self, fn(_, send_to) ->
      spawn(Chain, :counter, [send_to])
    end)

    # starts the count
    send last, 0

    receive do
      final_answer -> "Result is #{inspect(final_answer)}"
    end
  end

  def run(n) do
    IO.puts inspect :timer.tc(Chain, :create_processes, [n])
  end
end