defmodule Day1 do
  import Helper

  @input_file "priv/day1.txt"

  @doc """
  Example:
    iex> list = ~w/199 200 208 210 200 207 240 269 260 263/
    iex> Day1.ex1(list)
    7
  """
  def ex1(list \\ []) do
    input =
      case Mix.env() do
        :test -> list
        :dev -> parse_file(@input_file, map_by: &map_by/1)
      end

    ex1_calc(input, [])
    |> Enum.filter(&(&1 == :increase))
    |> Enum.count()
  end

  @doc """
  Example:
    iex> list = ~w/199 200 208 210 200 207 240 269 260 263/
    iex> Day1.ex2(list)
    5
  """
  def ex2(list \\ []) do
    input =
      case Mix.env() do
        :test -> Enum.map(list, &map_by/1)
        :dev -> parse_file(@input_file, map_by: &map_by/1)
      end

    calc_window(input, [])
    |> Enum.reverse()
    |> ex1_calc([])
    |> Enum.filter(&(&1 == :increase))
    |> Enum.count()
  end

  defp ex1_calc([_], acc), do: acc

  defp ex1_calc([val1, val2 | t], acc) when val2 > val1,
    do: ex1_calc([val2 | t], [:increase | acc])

  defp ex1_calc([val1, val2 | t], acc) when val2 < val1,
    do: ex1_calc([val2 | t], [:decrese | acc])

  defp ex1_calc([_, val2 | t], acc), do: ex1_calc([val2 | t], acc)

  defp calc_window([v1, v2, v3 | t], acc) do
    sum = [v1, v2, v3] |> Enum.sum()
    calc_window([v2, v3 | t], [sum | acc])
  end

  defp calc_window(_, acc), do: acc

  defp map_by(row) do
    row |> String.to_integer()
  end
end
