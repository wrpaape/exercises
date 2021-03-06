defmodule Sequence do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  # def start(_type, _args) do
  #   import Supervisor.Spec, warn: false

  #   children = [
  #     worker(Sequence.Worker, [123]),
  #   ]

  #   # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
  #   # for other strategies and supported options
  #   opts = [strategy: :one_for_one, name: Sequence.Supervisor]
  #   {:ok, _pid} = Supervisor.start_link(children, opts)
  # end

  def start(_type, _args) do
    :sequence
    |> Application.get_env(:initial_number)
    |> Sequence.Supervisor.start_link
  end
end
