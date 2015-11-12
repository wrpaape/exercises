defmodule MultiProcess do
  def child(parent_pid) do
    msg = String.duplicate("I CAN'T TAKE IT ANYMORE\n", 10)
    send parent_pid, {self, msg <> "RIP #{inspect self}"}
    exit :cant_take_it_anymore
  end

  def raise_child do
    Process.flag(:trap_exit, true)
    child_pid = spawn_link(MultiProcess, :child, [self])

    :timer.sleep 500

    receive do
      {^child_pid, msg} -> IO.puts msg
      after 1000        -> IO.puts "*crickets chirping*"
    end
    
    receive do
      {:EXIT, ^child_pid, reason} -> IO.puts "exited bc #{reason}"
    end
  end

  def pmap(collection, fun) do
    parent = self
    collection
    |> Enum.map(fn(elem) ->
         spawn_link(fn -> send(parent, {self, fun.(elem)}) end)
       end)
    |> Enum.map(fn(pid) ->
         receive do {^pid, result} -> result end
       end)
  end
end