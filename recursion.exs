defmodule Recursion do
  @moduledoc """
  Contains functions implementing recursion.
  """

  def factorial(0), do: 1
  def factorial(num) when num > 0, do: num * factorial(num - 1)



  # def guess(actual, first..last) when actual < first do
  #   next_guess = div(last - first, 2)
  #   guess(actual, first - next_guess..first)
  # end

  # # end
  # def guess(actual, first..last) when actual > last do
  #   next_guess = div(last - first, 2)
  #   guess(actual, first - next_guess..first)
  # end

  # defp split_delta(max, min)
  #   div(max - min, 2)
  # end

  # defp next_range(actual, guess, _..last) when guess < actual do
  #   split_delta(guess + 1, )
  # end

  # defp next_range(actual, guess, first..last) when first == last, do: actual

  def guess(actual, guessed, _..last) when guessed < actual do
    guess(actual, (guessed + 1)..last)
  end

  def guess(actual, guessed, first.._) when guessed > actual do
    guess(actual, first..(guessed - 1))
  end

  def guess(_, correct_guess, _) do
    correct_guess
  end

  # def guess(actual, range) when not actual in range do
  #   "#{actual} not in range #{range.first}..#{range.last}"
  # end

  def guess(actual, first..last) do
    guessed = first + div(last - first, 2)
    IO.puts "Is it #{guessed}?"
    IO.inspect{guessed, first, last} 
    guess(actual, guessed, first..last)
  end
end

