defmodule Fetch do
  defp fetch!({:ok, result}), do: result
  def dim(dim), do: apply(:io, dim, []) |> fetch! |> - 1
end

defmodule MultiProcess do
  def async_map(collection, fun) do
    parent = self
    collection
    |> Enum.map(fn(elem) ->
      spawn_link(fn ->
        parent |> send({:response, fun.(elem)})
      end)
    end)
    |> Enum.map(fn(_pid) ->
      receive do
        {:response, result} -> result
      end
    end)
  end
end

defmodule Bell do
  @std_max 4
  @num_passes 10
  @rows Fetch.dim(:rows)
  @columns Fetch.dim(:columns)
  @bucket_width 2 * @std_max / @columns
  @num_queries 40 * @rows 


  def curve do
    # System.cmd("clear", [])
    spawn_buckets
    |> List.duplicate(@num_passes)
    |> MultiProcess.async_map(&generate_distribution/1)
    |> average_distributions
    |> print
  end

  def report(num_passes \\ 1) do
    1..num_passes
    |> Enum.each(fn(pass) ->
      [
        map: &Enum.map/2,
        async: &MultiProcess.async_map/2
      ]
      |> Enum.each(&time_map(&1, pass))

      wrap("", "/\\")
      |> IO.puts
    end)
  end

  defp format({display, time}), do: "#{display}:  #{time / 1.0e6} s"
  defp wrap(results, char) do
    String.duplicate(char, @columns |> div(2))
    |> List.duplicate(2)
    |> Enum.join("\n" <> results <> "\n")
  end

  defp time_map({display, map_fun}, pass) do
    "timing #{inspect map_fun} (pass #{pass})"
    |> wrap(" ")
    |> IO.puts

    {time_total, result} =
      :timer.tc(fn ->
        {time1, buckets} =
          :timer.tc(&spawn_buckets/0)
        
        {time2, duped_buckets} =
          :timer.tc(&List.duplicate/2, [buckets, @num_passes])

        {time3, dists} = :timer.tc(fn ->
          apply(map_fun, [duped_buckets, &generate_distribution/1])
        end)

        {time4, _avg} =
          :timer.tc(&average_distributions/1, [dists])

        [
          spawn_buckets: time1,
          duped_buckets: time2,
          generate_dist: time3,
          average_dists: time4
        ]
        |> Enum.map(&format/1)
      end)

    [format({display, time_total}) | result]
    |> Enum.join("\n")
    |> wrap("*")
    |> IO.puts
  end


  defp spawn_buckets do
    1..@columns
    |> Enum.map(&spawn(__MODULE__, :bucket, [&1]))
    |> Enum.map(&List.duplicate(&1, @num_queries))
  end

  defp generate_distribution(buckets) do
    buckets
    |> Enum.map(fn(pids) ->
      pids
      |> Enum.map(&query_bucket/1)
      |> Enum.reduce(&(&1 + &2))
    end)
  end

  defp average_distributions(distributions) do
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

  defp stash({lbound, rbound}) do
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
