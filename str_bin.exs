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
end