defmodule Recursion do
  @moduledoc """
  Contains functions implementing recursion.
  """

  def factorial(0), do: 1
  def factorial(num) when num > 0, do: num * factorial(num - 1)

  # def guess(actual, range) when not actual in range do
  #   "#{actual} not in range #{range.first}..#{range.last}"
  # end

  def guess(actual, first..last) do
    guessed = first + div(last - first, 2)
    IO.puts "Is it #{guessed}?"
    _guess(actual, guessed, first..last)
  end

  defp _guess(actual, guessed, _..last) when guessed < actual do
    guess(actual, (guessed + 1)..last)
  end

  defp _guess(actual, guessed, first.._) when guessed > actual do
    guess(actual, first..(guessed - 1))
  end

  defp _guess(_actual, correct_guess, _range) do
    correct_guess
  end


  def sum([]),           do: 0
  def sum([head | tail]), do: head + sum(tail)
end

