defmodule Scheduler do
  def run(num_processes, module, func, to_calculate) do
    1..num_processes
    |> Enum.map(fn(_) ->
         spawn(module, func, [self])
       end)
    |> schedule_processes(to_calculate, [])
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [next | tail] = queue
        send(pid, {:solve, next, self})
        schedule_processes(processes, tail, results)

      {:ready, pid} ->
        send(pid, {:shutdown})
        if length(processes) > 1 do
          processes
          |> List.delete(pid)
          |> schedule_processes(queue, results)
        else
          results
          |> Enum.sort
        end

      {:answer, num, result, _pid} ->
        processes
        |> schedule_processes(queue, [{num, result} | results])
    end
  end
end