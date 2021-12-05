defmodule Day3 do
  import Helper

  @input_file "priv/day3.txt"

  @doc """
  Example
    iex> list = ["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000", "11001", "00010", "01010"]
    iex> Day3.part1(list)
    198
  """

  def part1(list \\ nil) do
    gamma_rate =
      (list || parse_file(@input_file))
      |> Enum.map(&String.graphemes/1)
      |> Enum.zip()
      |> Enum.map(&find_gamma/1)
      |> Enum.map(&elem(&1, 0))
      |> Enum.join("")

    gamma_value = String.to_integer(gamma_rate, 2)

    rate_length =
      gamma_rate
      |> String.length()

    epsilon_value =
      String.duplicate("1", rate_length)
      |> String.to_integer(2)
      |> Kernel.-(gamma_value)

    gamma_value * epsilon_value
  end

  @doc """
  Example
    iex> list = ["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100", "10000", "11001", "00010", "01010"]
    iex> Day3.part2(list)
    230
  """
  def part2(list \\ nil) do
    ratings = list || parse_file(@input_file)

    o2_rating(ratings) * co2_rating(ratings)
  end

  defp o2_rating(ratings, pos \\ 0)
  defp o2_rating([value], _), do: String.to_integer(value, 2)

  defp o2_rating(ratings, pos) do
    most_common =
      get_frequencies(ratings, pos, &>/2)
      |> hd

    ratings_1 = Enum.filter(ratings, &(String.at(&1, pos) == most_common))

    o2_rating(ratings_1, pos + 1)
  end

  defp co2_rating(ratings, pos \\ 0)
  defp co2_rating([value], _), do: String.to_integer(value, 2)

  defp co2_rating(ratings, pos) do
    least_common =
      get_frequencies(ratings, pos, &<=/2)
      |> hd

    ratings_1 = Enum.filter(ratings, &(String.at(&1, pos) == least_common))

    co2_rating(ratings_1, pos + 1)
  end

  defp get_frequencies(ratings, pos, sort_fn) do
    Enum.map(ratings, &String.at(&1, pos))
    |> Enum.frequencies()
    |> Enum.sort_by(&elem(&1, 1), sort_fn)
    |> Enum.map(&elem(&1, 0))
  end

  defp find_gamma(pos_row_0) do
    Tuple.to_list(pos_row_0)
    |> Enum.frequencies_by(& &1)
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
    |> hd
  end
end
