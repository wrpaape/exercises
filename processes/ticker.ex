defmodule Ticker do
  @interval 5000
  @ticker :ticker
  @name_bucket :name_bucket
  @names ~w(Billy Bobby Bowie Jannet John Joe James Jim Bob Fred Frank Alice Ann)

  def start do
    ticker_pid = spawn(__MODULE__, :generator, [[], []])
    :global.register_name(@ticker, ticker_pid)
    
    name_bucket_pid = spawn(__MODULE__, :name_bucket, [%{}, @names])
    :global.register_name(@name_bucket, name_bucket_pid)

    :timer.send_interval(@interval, ticker_pid, {:tick})
  end

  def register(pid) do
    send(:global.whereis_name(@ticker), {:register, pid})
  end

  def name_bucket(clients, [name | rem]) do
    receive do
      {:name, pid} -> name_client(clients, name, pid, rem)
    end
  end

  def name_bucket(clients, []) do
    IO.puts """
    ++++++++++++++++++++
    + OUT OF NAMES LOL +
    ++++++++++++++++++++
    """
    receive do
      {:name, pid} -> name_client(clients, pid, pid, [])    
    end
  end

  def name_client(clients, name, pid, rem) do
    send(:global.whereis_name(@ticker), {:named, name})

    clients
    |> Map.put_new(name, pid)
    |> name_bucket(rem)
  end

  def generator(todo, done) do
    receive do
      {:register, pid} ->
        IO.puts """
          $$$$$$$$$$$$$$$$$$$$$$$$$$$$
           registering #{inspect pid}...
          """
        send(:global.whereis_name(@name_bucket), {:name, pid})
        receive do
          {:named, name} ->
            IO.puts """
             welcome #{inspect name}!
            $$$$$$$$$$$$$$$$$$$$$$$$$$$$
            """
            send(pid, {:named, name})
        end
        generator(todo, [pid | done])

      {:tick} ->
        IO.puts """
          ***********************************************
          *                     tick                    *
          *                      .                      *
          *                      .                      *
          *                      .                      *
          *               SENDING THE TOCK!             *
          ***********************************************
          """
        tock_next(todo, done)
    end
  end

  def tock_next([], []),              do: generator([], [])
  def tock_next([next | todo], done), do: send_tock(next, todo, done)
  def tock_next([], done)             do
    [next | todo] = Enum.reverse(done)
    send_tock(next, todo, [])
  end

  def send_tock(pid, todo, done) do
    IO.puts """
      ***********************
        will tock: #{inspect pid}
        todo:      #{inspect todo}
        done:      #{inspect done}
      ***********************
      """
    send(pid, {:tock})
    generator(todo, [pid | done])
  end
end




defmodule Client do
  def start do
    pid = spawn(__MODULE__, :new, [])
    Ticker.register(pid)
  end

  def new do
    receive do
      {:named, name} ->
        IO.puts """
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          Hello everybody, my name is #{inspect name}
          and I want the tock
          GIVE ME THE TOCK!
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        """
        wait_for_the_tock(name)
    end
  end

  def wait_for_the_tock(name) do
    receive do
      {:tock} ->
        msg = "* I, #{inspect name} (#{inspect self}), JUST GOT TOCKED! *"
        border = String.duplicate("*", String.length(msg))
        List.duplicate(".", 3)
        |> Enum.into([border, msg, border])
        |> Enum.join("\n")
        |> IO.puts
        wait_for_the_tock(name)
    end
  end
end