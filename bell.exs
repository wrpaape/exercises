defmodule Fetcher do
  defp fetch!({:ok, result}), do: result
  def fetch_dim(dim), do: apply(:io, dim, []) |> fetch! |> - 1
end

defmodule Parallel do
  @parent self

  def map(collection, fun) do
    collection
    |> Enum.map(fn(elem) ->
      spawn_link(fn ->
        send(@parent, {self, fun.(elem)})
      end)
    end)
    |> Enum.map(fn(pid) ->
      receive do
        {^pid, result} -> result
      end
    end)
  end
end

defmodule Bell do
  use Fetcher

  @std_max 3.5
  @num_passes 100
  @rows Fetcher.fetch_dim(:rows)
  @columns Fetcher.fetch_dim(:columns)
  @bucket_width 2 * @std_max / @columns
  @num_queries 50 * @rows 


  def curve do
    # System.cmd("clear", [])
    use Parallel
    spawn_buckets
    |> List.duplicate(@num_passes)
    |> Parallel.map(&generate_distribution/1)
    |> average_distributions
    |> print
  end

  def spawn_buckets do
    1..@columns
    |> Enum.map(&spawn(__MODULE__, :bucket, [&1]))
    |> Enum.map(&List.duplicate(&1, @num_queries))
  end

  def generate_distribution(buckets) do
    buckets
    |> Enum.map(fn(pids) ->
      pids
      |> Enum.map(&query_bucket/1)
      |> Enum.reduce(&(&1 + &2))
    end)
  end

  def average_distributions(distributions) do
    distributions
    |> Enum.reduce(fn(distribution, acc) ->
      distribution
      |> Enum.zip(acc)
      |> Enum.map(fn({e1, e2}) ->
        e1 + e2
      end)
    end)
    |> Enum.map(&(&1 / @num_passes))
  end

  def bucket(n) do
    min = (n - 1) * @bucket_width - @std_max
    
    {min, min + @bucket_width} |> stash
  end

  def stash({lbound, rbound}) do
    in_bucket? = &(&1 >= lbound and &1 < rbound)

    receive do
      {:query, val, pid} ->
        result = if in_bucket?.(val), do: 1, else: 0
        send(pid, {:response, result})
        {lbound, rbound} |> stash
    end
  end

  defp query_bucket(pid) do
    send(pid, {:query, :rand.normal, self})

    receive do
      {:response, result} -> result
    end
  end

  defp print(distribution) do
    @rows..0
    |> Enum.map_join("\n", fn(count) ->
      distribution
      |> Enum.map_join(&(if &1 > count, do: "X", else: " "))
    end)
    |> IO.puts
  end
end
