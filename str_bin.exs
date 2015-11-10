defmodule StrBin do
  @moduledoc """
  Contains functions implementing strings and binaries.
  """
  def ascii?([bin | _t]), do: bin in ?\s..?~

  def anagram?(w1, w2) do
    if length(w1) == length(w2) and Enum.empty?(w2 -- w1), do: true, else: false
  end

  defp _parse_num(num) do
    import List, only: [to_float: 1, to_integer: 1]

    if ?. in num, do: to_float(num), else: to_integer(num)
  end

  def calculate(exp) do
    import Enum, only: [filter: 2, split_while: 2, map: 2]

    {raw_num1, [op | raw_num2]} =
      exp
      |> filter(&(&1 != ?\s))
      |> split_while(&(!&1 in '+-*/'))

    nums = map [raw_num1, raw_num2], &_parse_num/1
    fun =
      case op do
        ?+ -> &+/2
        ?- -> &-/2
        ?* -> &*/2
        ?/ -> &//2
      end

    apply fun, nums
  end

  defp _len(len, max_len), do: len + div(max_len - len, 2)
  def center(strings) do
    lens_strs = Enum.map strings, &{String.length(&1), &1}
    {max_len, _str} = Enum.max lens_strs

    Enum.each lens_strs, fn {len, str} ->
      str |> String.rjust(len |> _len(max_len)) |> IO.puts
    end
  end

  # def cap_sents(<<>>),                      do: []
  # def cap_sents(<<?., ?\s, h, t::binary>>), do: <<?., ?\s, String.upcase(h), cap_sents(t)>>
  # def cap_sents(<<h, t::binary>>),          do: <<String.downcase(h), cap_sents(t)>>
  def cap_sents(sents) do
    sents
    |> String.split(~r{(^|\.\s*)(?<empty>)(?=\w)}, on: [:empty])
    |> Enum.map_join(&String.capitalize/1)
  end

end