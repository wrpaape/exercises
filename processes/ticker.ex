defmodule Ticker do
  @interval 2000
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], []])
    :global.register_name(@name, pid)
    :timer.send_interval(@interval, pid, {:do_tick})
  end

  def register(client_pid) do
    send(:global.whereis_name(@name), {:register, client_pid})
  end

  def generator(todo, done) do
    receive do
      {:register, pid} ->
        IO.puts "registering #{inspect pid}\n\n"
        generator(todo, [pid | done])
      {:do_tick} ->
        IO.puts "** tick **"
        send_tick(todo, done)
    end
  end

  def send_tick([next | todo], done) do
    IO.puts "tock: #{inspect next}"
    IO.puts "todo: #{inspect todo}"
    IO.puts "done: #{inspect done}"

    send(next, {:tick})
    generator(todo, [next | done])
  end

  def send_tick([], []) do
    IO.puts "tock: no clients!"
    generator([], [])
  end

  def send_tick([], done) do
    [next | todo] =
      done
      |> Enum.reverse
    IO.puts "tock: #{inspect next}"
    IO.puts "todo: #{inspect todo}"
    IO.puts "done: []"

    send(next, {:tick})
    generator(todo, [next])
  end
end

defmodule Client do
  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      {:tick} ->
        IO.puts "tock in client #{inspect self}\n\n"
        receiver
    end
  end
end