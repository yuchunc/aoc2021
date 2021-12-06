defmodule Day6 do
  import Helper

  @input "priv/day6.txt"

  @doc """
  Example
  iex> input = "3,4,3,1,2"
  iex> days = 80
  iex> Day6.part1(input, days)
  5934
  """
  def part1(input, days) do
    fishes = parse_file(input, split_by: ",", map_by: &map_fn/1)

    1..days
    |> Enum.reduce(fishes, &compute_day/2)
    |> length
  end

  defp compute_day(_, fishes) do
    {fishes, babies} =
      Enum.map_reduce(fishes, [], fn
        0, babies -> {6, [8 | babies]}
        fish, babies -> {fish - 1, babies}
      end)

    fishes ++ babies
  end

  @doc """
  Example
  iex> input = "3,4,3,1,2"
  iex> days = 256
  iex> Day6.part2(input, days)
  26984457539
  """
  def part2(input, days) do
    parse_file(@input, split_by: ",", map_by: &map_fn/1)
    |> Enum.frequencies()
    |> Map.to_list()
    |> calc_fish(days)
  end

  defp calc_fish(fish_counts, 0), do: fish_counts |> Keyword.values() |> Enum.sum()

  defp calc_fish(fish_counts, days) do
    fish_counts_1 =
      Enum.flat_map(fish_counts, fn
        {0, count} -> [{6, count}, {8, count}]
        {fish_type, count} -> [{fish_type - 1, count}]
      end)
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Enum.map(fn {fish_type, counts} -> {fish_type, Enum.sum(counts)} end)

    calc_fish(fish_counts_1, days - 1)
  end

  defp map_fn(element) do
    String.to_integer(element)
  end
end
