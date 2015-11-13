defmodule Stack.Server do
  use GenServer

  # External API

  def start_link(stack) do
    GenServer.start_link(__MODULE__, stack, name: __MODULE__)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def push(delta) do
    GenServer.cast(__MODULE__, {:push, delta})
  end

  # GenServer implementation

  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end
  
  def handle_call(:pop, _from, []) do
    IO.puts "NOOOOOOOOOOOOOOOOOOOooooooooooo"
    exit(:WHAT_DID_YOU_DO?)
  end

  def handle_cast({:push, head}, tail) do
    {:noreply, [head | tail]}
  end

  def format_status(_reason, [_pdict, state]) do
    [data: [{'State', "My current state is '#{inspect state}', and I'm happy"}]]
  end

  def terminate(reason, state) do
    IO.puts "reason:"
    IO.inspect reason
    IO.puts "state:"
    IO.inspect state

  end
end