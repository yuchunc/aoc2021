defmodule Day8 do
  import Helper

  @input "priv/day8.txt"

  @doc """
  Example
    iex> input = \"""
    ...> be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
    ...> edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
    ...> fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
    ...> fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
    ...> aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
    ...> fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
    ...> dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
    ...> bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
    ...> egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
    ...> gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    ...> \"""
    iex> Day8.part1(input)
    26
  """
  def part1(input) do
    map_by = fn str ->
      [_, outputs] =
        str
        |> String.split(" | ", trim: true)

      String.split(outputs, " ", trime: true)
      |> Enum.frequencies_by(&String.length/1)
      |> Map.take([2, 4, 3, 7])
      |> Map.values()
    end

    parse_file(input, split_by: "\n", map_by: map_by)
    |> List.flatten()
    |> Enum.sum()
  end

  @doc """
  Example
    iex> input = \"""
    ...> be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
    ...> edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
    ...> fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
    ...> fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
    ...> aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
    ...> fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
    ...> dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
    ...> bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
    ...> egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
    ...> gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    ...> \"""
    iex> Day8.part2(input)
    61229
  """
  def part2(input) do
    map_by = fn str ->
      [hints, outputs] =
        str
        |> String.split(" | ", trim: true)

      dictionary =
        hints
        |> String.split(" ")
        |> Enum.map(&String.graphemes/1)
        |> gen_dictionary()

      outputs
      |> String.split(" ")
      |> Enum.map(fn combo ->
        combo_1 = combo |> String.graphemes() |> Enum.sort()
        Enum.find_index(dictionary, &(&1 == combo_1))
      end)
      |> Enum.join()
      |> String.to_integer()
    end

    parse_file(input, split_by: "\n", map_by: map_by)
    |> Enum.sum()
  end

  defp gen_dictionary(hints) do
    one = Enum.find(hints, &(length(&1) == 2))
    four = Enum.find(hints, &(length(&1) == 4))
    seven = Enum.find(hints, &(length(&1) == 3))
    eight = Enum.find(hints, &(length(&1) == 7))

    four_seven = four ++ seven

    six_lights = Enum.filter(hints, &(length(&1) == 6))
    five_lights = Enum.filter(hints, &(length(&1) == 5))

    [nine] = Enum.filter(six_lights, &(length(&1 -- four_seven) == 1))
    [two] = Enum.filter(five_lights, &(length(&1 -- nine) == 1))
    [three] = Enum.filter(five_lights, &(length(&1 -- two) == 1))
    [five] = five_lights -- [two, three]
    [lower_left] = eight -- nine
    [six] = Enum.filter(six_lights, &(length(&1 -- [lower_left | five]) == 0))
    [zero] = six_lights -- [nine, six]

    [zero, one, two, three, four, five, six, seven, eight, nine]
    |> Enum.map(&Enum.sort/1)
  end
end
