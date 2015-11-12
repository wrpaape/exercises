defmodule Fib do
  def solve(scheduler) do
    send(scheduler, {:ready, self})

    receive do
      {:solve, n, client} ->
        send(client, {:answer, n, fib_calc(n), self})
        solve(scheduler)
      {:shutdown} -> exit(:finished)
    end
  end

  # very inefficient, deliberately
  defp fib_calc(0), do: 0
  defp fib_calc(1), do: 1
  defp fib_calc(n), do: fib_calc(n - 1) + fib_calc(n - 2)
end

defmodule Time do
  def fun([module, func | args]) do
    apply(:timer, :tc, [module, func, args])
  end 
end

Code.load_file "scheduler.exs"
to_process = List.duplicate(37, 10)

Enum.each(1..10, fn(num_processes) ->
  {time, result} =
    [num_processes, Fib, :solve, to_process]
    |> Enum.into([Scheduler, :run])
    |> Time.fun

  if num_processes == 1 do
    IO.inspect result
    IO.puts "\n # time (s)"
  end

  :io.format "~2B ~.2f~n", [num_processes, time / 1_000_000]
end)
