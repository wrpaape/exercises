defmodule My do
  defmacro macro(param) do
    IO.inspect param
  end

  defmacro times_n(n) do

    fun_name =
      "times_"
      <> Integer.to_string(n)
      |> String.to_atom
    quote do
      def unquote(fun_name) (m), do: m * n
    end
  end
end