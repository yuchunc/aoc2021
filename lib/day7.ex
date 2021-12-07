defmodule Day7 do
  import Helper

  @input "priv/day7.txt"

  @doc """
  Example
    iex> input = "16,1,2,0,4,2,7,1,2,14"
    iex> Day7.part1(input)
    37
  """
  def part1(input) do
    crabs =
      parse_file(input, split_by: ",", map_by: &String.to_integer/1)
      |> Enum.frequencies()

    [min_crab | _] = crabs |> Map.keys() |> Enum.sort()
    find_min_fuel(crabs, min_crab, &get_freq_fuel/2)
  end

  @doc """
  Example
    iex> input = "16,1,2,0,4,2,7,1,2,14"
    iex> Day7.part2(input)
    168
  """
  def part2(input) do
    crabs =
      parse_file(input, split_by: ",", map_by: &String.to_integer/1)
      |> Enum.frequencies()

    [min_crab | _] = crabs |> Map.keys() |> Enum.sort()
    find_min_fuel(crabs, min_crab, &get_freq_fuel_2/2)
  end

  defp find_min_fuel(crab_freqs, position, fuel_fn) do
    fuel_total = position_fuel_total(position, crab_freqs, fuel_fn)
    find_min_fuel(crab_freqs, position, fuel_total, fuel_fn)
  end

  defp find_min_fuel(crab_freqs, position, prev_fuel_total, fuel_fn) do
    current_fuel_total = position_fuel_total(position, crab_freqs, fuel_fn)

    if current_fuel_total > prev_fuel_total do
      prev_fuel_total
    else
      find_min_fuel(crab_freqs, position + 1, current_fuel_total, fuel_fn)
    end
  end

  defp position_fuel_total(position, crab_freqs, fuel_fn) do
    Enum.map(crab_freqs, &apply(fuel_fn, [&1, position]))
    |> Enum.sum()
  end

  defp get_freq_fuel({crab, counts}, pos) do
    abs(crab - pos) * counts
  end

  defp get_freq_fuel_2({crab, counts}, pos) do
    # this sigma calcuation can be optimized using formula
    # n = abs(crab- pos)
    # n * (n + 1) / 2 * counts

    0..abs(crab - pos)
    |> Enum.sum()
    |> Kernel.*(counts)
  end
end
