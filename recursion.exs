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


  def sum([]),            do: 0
  def sum([head | tail]), do: head + sum(tail)


  def map([], _fun),           do: []
  def map([head | tail], fun), do: [fun.(head) | map(tail, fun)]


  def mapsum(list, fun), do: list |> map(fun) |> sum


  def max([]),                                       do: nil
  def max([max]),                                    do: max
  def max([head1, head2 | tail]) when head1 < head2, do: max([head2 | tail])
  def max([head1 | [_head2 | tail]]),                do: max([head1 | tail])


  def caesar([], _n),                do: []
  def caesar([head | tail], n),      do: [_c_add(head + n) | caesar(tail, n)]
  defp _c_add(char) when char < 97,  do: _c_add(char + 26)
  defp _c_add(char) when char > 122, do: _c_add(char - 26)
  defp _c_add(char),                 do: char


  def span(from, to) when from > to, do: raise "arguments must be of the form span(from, to) where from <= to"
  def span(to, to),                  do: [to]
  def span(from, to),                do: [from | span(from + 1, to)]


  def all?([], _con),    do: true
  def all?([h | t], con) do
    if con.(h) and all?(t, con), do: true, else: false
  end

  def each([], _fun),    do: :ok
  def each([h | t], fun) do
    fun.(h)
    each(t, fun)
  end

  def filter([], _con),    do: []
  def filter([h | t], con) do
    rest = filter(t, con)
    if(con.(h), do: [h | rest], else: rest)
  end
end

