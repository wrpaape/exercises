defmodule MultiProcess do
  def child(parent_pid) do
    msg = String.duplicate("I CAN'T TAKE IT ANYMORE\n", 10)
    send parent_pid, {self, msg <> "RIP #{inspect self}"}
    exit :cant_take_it_anymore
  end

  def run do
    {child_pid, _ref} = spawn_monitor(MultiProcess, :child, [self])
    
    :timer.sleep 500

    receive do
      {^child_pid, msg} -> IO.puts msg
    after 1000 ->
      IO.puts "*crickets chirping*"
    end
  end
end