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


  defp _tax_rates, do: [NC: 0.075, TX: 0.08]
  defp _orders, do: [
    [id: 123, ship_to: :NC, net_amount: 100.00],
    [id: 124, ship_to: :OK, net_amount:  35.50],
    [id: 125, ship_to: :TX, net_amount:  24.00],
    [id: 126, ship_to: :TX, net_amount:  44.80],
    [id: 127, ship_to: :NC, net_amount:  25.00],
    [id: 128, ship_to: :MA, net_amount:  10.00],
    [id: 129, ship_to: :CA, net_amount: 102.00],
    [id: 120, ship_to: :NC, net_amount:  50.00]]
    
  defp total_amount([_, ship_to: state, net_amount: net_amount]) do
    (1 + (_tax_rates[state] || 0)) * net_amount
  end

  def orders_with_total do
    for order <- _orders,
    do: Keyword.put_new(order, :total_amount, total_amount(order))
  end
end