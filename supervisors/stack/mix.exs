defmodule Stack.Mixfile do
  use Mix.Project

  def project do
    [app: :stack,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger],
    mod: {Sequence, [intial_stack: bell_curve(50, 3.5)},,
     mod: {Stack, []}]
  end

  def bell_curve(num_buckets, std_max)
    bucket_width = 2 * std_max / num_buckets
    bucket_values = fn(n) ->
      (n - 1..n)
      |> Enum.map(fn(n) ->
        n * bucket_width - std_max
      end)
    end

    tokens = List.duplicate({"X", "O"}, 100)
    1..num_buckets
    |> Enum.map(fn(n) ->
      tokens
      |> Enum.map(fn({hit, miss}) ->
        norm = :rand.normal
        {min, max} = bucket_values.(n)
        if norm >= min and norm < max, do: hit, else: miss
      end)
      |> Enum.sort
      |> Enum.join
    end)
  end

  def
  # defp rand_stack(last_index) do
  #   0..last_index
  #   |> Enum.map(&rand_elt/1)
  # end

  # defp rand_elt(index) do
  #   3
  #   |> :rand.uniform
  #   |> case do
  #     1 -> :rand.uniform(3)
  #     2 -> 200 * (rand - 0.5)
  #     3 ->
  #       65..122
  #       |> Enum.to_list
  #       |> Enum.take_random(trunc(10 * rand) + 1)
  #       |> List.to_string

  #   end
  # end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    []
  end
end
