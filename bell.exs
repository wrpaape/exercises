defmodule Fetcher do
  defp fetch({:ok, result}), do: result
  def fetch_dim(dim), do: apply(:io, dim, []) |> fetch |> - 1
end

defmodule Bell do
  import Fetcher

  @std_max 3.5
  @num_buckets fetch_dim(:columns)
  @bucket_width 2 * @std_max / @num_buckets
  @max_bucket_count 30 * fetch_dim(:rows)

  def curve do
    # System.cmd("clear", [])
    # clear
    1..@num_buckets
    |> Enum.map(&spawn(__MODULE__, :bucket, [&1]))
    |> Enum.map(&List.duplicate(&1, @max_bucket_count))
    |> Enum.map(fn(pids) ->
      pids
      |> Enum.map(&query_bucket/1)
      |> Enum.reduce(&(&1 + &2))
    end)
    |> print
  end

  def bucket(n) do
    min = (n - 1) * @bucket_width - @std_max
    
    {min, min + @bucket_width} |> stash
  end

  def stash(bucket) do
    receive do
      {:query, val, pid} ->
        result = if val |> in_range?(bucket), do: 1, else: 0
        
        send(pid, {:response, result})
        stash(bucket)
    end
  end

  defp in_range?(val, {min, max}), do: val >= min and val < max

  defp query_bucket(bucket_pid) do
    bucket_pid
    |> send({:query, :rand.normal, self})

    receive do
      {:response, result} -> result
    end
  end

  defp print(distribution) do
    distribution
    |> Enum.max
    |> Range.new(1)
    |> Enum.map(fn(count) ->
      distribution
      |> Enum.map(fn(bucket_count) ->
        if bucket_count >= count, do: "X", else: " "
      end)
      |> Enum.join
    end)
    |> Enum.join("\n")
    |> IO.puts
  end
end
