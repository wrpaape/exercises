defmodule Comp do
  @moduledoc """
  Contains functions implementing comprehensions.
  """

  import Recursion, only: [span: 2, all?: 2]

  def primes_to(n) do
    for i <- span(3, n),
      all?(span(2, i - 1), &(rem(i, &1) != 0 )),
      into: [2],
      do: i
  end

  def with_total(orders, tax_rates) do
    for order <- orders,
    do: Keyword.put_new(order,
      :total_amount,
      (1 + (tax_rates[order[:ship_to]] || 0)) * order[:net_amount])
  end
end