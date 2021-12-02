defmodule Day2 do
  import Helper

  @input_file "priv/day2.txt"

  @doc """
  Example
    iex> list = [ {"forward", 5}, {"down", 5}, {"forward", 8}, {"up", 3}, {"down", 8}, {"forward", 2} ]
    iex> Day2.part1(list)
    150
  """
  def part1(list \\ nil) do
    {x, y} =
      (list || parse_file(@input_file, map_by: &map_by/1))
      |> compute_moves({0, 0})

    x * y
  end

  @doc """
  Example
    iex> list = [ {"forward", 5}, {"down", 5}, {"forward", 8}, {"up", 3}, {"down", 8}, {"forward", 2} ]
    iex> Day2.part2(list)
    900
  """
  def part2(list \\ nil) do
    {x, _, d} =
      (list || parse_file(@input_file, map_by: &map_by/1))
      |> compute_moves_2({0, 0, 0})

    x * d
  end

  defp compute_moves([], pos), do: pos
  defp compute_moves([{"forward", move} | t], {x, y}), do: compute_moves(t, {x + move, y})
  defp compute_moves([{"up", move} | t], {x, y}), do: compute_moves(t, {x, y - move})
  defp compute_moves([{"down", move} | t], {x, y}), do: compute_moves(t, {x, y + move})

  defp compute_moves_2([], pos), do: pos

  defp compute_moves_2([{"forward", move} | t], {x, 0, d}),
    do: compute_moves_2(t, {x + move, 0, d})

  defp compute_moves_2([{"forward", move} | t], {x, y, d}),
    do: compute_moves_2(t, {x + move, y, y * move + d})

  defp compute_moves_2([{"up", move} | t], {x, y, d}), do: compute_moves_2(t, {x, y - move, d})
  defp compute_moves_2([{"down", move} | t], {x, y, d}), do: compute_moves_2(t, {x, y + move, d})

  defp map_by(row) do
    [direction, str_move] = String.split(row, " ")
    {direction, String.to_integer(str_move)}
  end
end
