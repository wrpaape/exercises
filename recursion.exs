defmodule Recursion do
  @moduledoc """
  Contains functions implementing recursion.
  """

  def factorial(0), do: 1
  def factorial(num) when num > 0, do: num * factorial(num - 1)

  def guess(actual, range) when not actual in range
  def guess(actual, first..last) when first == last, do: actual
  def guess(actual, first..last) when actual in firs
    next_guess = div
    IO.puts "Is it #{}"
  end
end