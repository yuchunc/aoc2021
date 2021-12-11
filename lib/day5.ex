defmodule Day5 do
  @input "priv/day5.txt"

  import Helper

  @doc """
  Example:
    iex> input = \"""
    ...> 0,9 -> 5,9
    ...> 8,0 -> 0,8
    ...> 9,4 -> 3,4
    ...> 2,2 -> 2,1
    ...> 7,0 -> 7,4
    ...> 6,4 -> 2,0
    ...> 0,9 -> 2,9
    ...> 3,4 -> 1,4
    ...> 0,0 -> 8,8
    ...> 5,5 -> 8,2
    ...> \"""
    iex> Day5.part1(input)
    5
  """
  def part1(input \\ nil) do
    parse_file(input, split_by: "\n", map_by: &map_fn/1)
    |> Enum.filter(fn
      [x, _, x, _] -> true
      [_, y, _, y] -> true
      _ -> false
    end)
    |> Enum.flat_map(&build_points/1)
    |> Enum.frequencies()
    |> Enum.filter(&(elem(&1, 1) >= 2))
    |> Enum.count()
  end

  @doc """
  Example:
    iex> input = \"""
    ...> 0,9 -> 5,9
    ...> 8,0 -> 0,8
    ...> 9,4 -> 3,4
    ...> 2,2 -> 2,1
    ...> 7,0 -> 7,4
    ...> 6,4 -> 2,0
    ...> 0,9 -> 2,9
    ...> 3,4 -> 1,4
    ...> 0,0 -> 8,8
    ...> 5,5 -> 8,2
    ...> \"""
    iex> Day5.part2(input)
    12
  """
  def part2(input \\ nil) do
    parse_file(input, split_by: "\n", map_by: &map_fn/1)
    |> Enum.flat_map(&build_points/1)
    |> Enum.frequencies()
    |> Enum.filter(&(elem(&1, 1) >= 2))
    |> Enum.count()
  end

  defp map_fn(str) do
    [x1, y1, x2, y2] =
      String.split(str, [" -> ", ","], trim: true)
      |> Enum.map(&String.to_integer/1)
  end

  defp build_points([x1, y1, x2, y2]) when x1 == x2 or y1 == y2 do
    for x <- x1..x2, y <- y1..y2 do
      {x, y}
    end
  end

  defp build_points([x1, y1, x2, y2]) do
    {x1, y1, x2, y2} =
      if x2 < x1 do
        {x2, y2, x1, y1}
      else
        {x1, y1, x2, y2}
      end

    slope =
      if y2 < y1 do
        -1
      else
        1
      end

    shift = y1 - slope * x1

    for x <- x1..x2 do
      {x, slope * x + shift}
    end
  end
end
