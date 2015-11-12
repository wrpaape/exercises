defmodule Ticker do
  @interval 2000
  @ticker :ticker
  @name_bucket :name_bucket
  @names = ~w(Billy Bobby Bowie Jannet John Joe James Jim Bob Fred Frank Alice Ann)

  def start do
    ticker_pid = spawn(__MODULE__, :generator, [[], []])
    :global.register_name(@ticker, ticker_pid)
    
    name_bucket_pid = spawn(__MODULE__, :name_bucket, [@names, %{}])
    :global.register_name(@name_bucket, name_bucket_pid)

    :timer.send_interval(@interval, pid, {:do_tick})
  end

  def register(pid) do
    send(:global.whereis_name(@ticker), {:register, pid, name})
  end

  def name_bucket([next | todo], assigned) do
    receive do
      {:name, pid} ->


    end
  end

  def generator(todo, done) do
    receive do
      {:register, pid} ->
        IO.puts "registering #{inspect pid}..."
        send(:global.whereis_name(@name_bucket), {:name, pid})
        receive do
          {:assigned, name} ->
            IO.puts "** welcome #{inspect name}! **\n"
        end

        generator(todo, [client| done])
      {:do_tick} ->
        IO.puts "**********************"
        IO.puts "*    ABOUT TO TIC    *"
        IO.puts "**********************"
        send_tick(todo, done)
    end
  end

  def send_tick([next | todo], done) do
    IO.puts """
    **********************
     tock: #{inspect next}
     todo: #{inspect todo}
     done: #{inspect done}
    **********************
    """

    send(next, {:tick})
    generator(todo, [next | done])
  end

  def send_tick([], []) do
    IO.puts "tock: no clients!"
    generator([], [])
  end

  def send_tick([], done) do
    [next | todo] = Enum.reverse(done)
    IO.puts """
    **********************
     tock: #{inspect next}
     todo: #{inspect todo}
     done: []
    **********************
    """
    send(next, {:tick})
    generator(todo, [next])
  end
end

defmodule Client do
  def name(pid) do
  end

  def kill(pid) do
    send()
  end

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