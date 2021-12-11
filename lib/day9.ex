defmodule Day9 do
  import Helper

  @input "priv/day9.txt"

  @doc """
  Example
  iex> input = \"""
  ...> 2199943210
  ...> 3987894921
  ...> 9856789892
  ...> 8767896789
  ...> 9899965678
  ...> \"""
  iex> Day9.part1(input)
  15
  """
  def part1(input) do
    metrics = parse_file(input, split_by: "\n", map_by: &map_by/1)

    column_low_points =
      metrics
      |> flip_metric
      |> Enum.map(&find_low_points/1)
      |> flip_metric
      |> List.flatten()

    row_low_points = Enum.flat_map(metrics, &find_low_points/1)

    [List.flatten(metrics), column_low_points, row_low_points]
    |> Enum.zip()
    |> Enum.flat_map(fn
      {point, true, true} -> [point]
      _ -> []
    end)
    |> Enum.map(&(&1 + 1))
    |> Enum.sum()
  end

  defp find_low_points(list) do
    [nil | list]
    |> Enum.chunk_every(3, 1, [nil])
    |> Enum.map(fn
      [nil, target, n1] -> target < n1
      [n1, target, nil] -> target < n1
      [n1, target, n2] -> target < n1 and target < n2
    end)
  end

  defp flip_metric(lists), do: Enum.zip(lists) |> Enum.map(&Tuple.to_list/1)

  @doc """
  Example
  iex> input = \"""
  ...> 2199943210
  ...> 3987894921
  ...> 9856789892
  ...> 8767896789
  ...> 9899965678
  ...> \"""
  iex> Day9.part2(input)
  1134

  This impl gives correct result to test, but not input *facepalm*
  1045660 is too low
  """
  def part2(input) do
    parse_file(input, split_by: "\n", map_by: &map_by/1)
    |> construct_basin([], [])
    |> Enum.map(&length/1)
    |> Enum.sort(&>=/2)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp construct_basin([], wips, done) do
    wips
    |> Enum.map(&List.flatten/1)
    |> Kernel.++(done)
  end

  defp construct_basin([row | rows], wip, done) do
    current_row =
      row
      |> Enum.with_index()
      |> Enum.chunk_by(&(elem(&1, 0) == 9))
      |> Enum.reject(&(&1 |> hd |> elem(0) == 9))
      |> Enum.map(fn set ->
        Enum.map(set, &elem(&1, 1))
      end)

    {wip_1, new_done} = check_row_basin(wip, [], [], current_row)

    construct_basin(rows, wip_1, done ++ new_done)
  end

  defp check_row_basin([], wip, done, remaining_current) do
    remaining = Enum.map(remaining_current, &[&1])

    {wip ++ remaining, done}
  end

  defp check_row_basin([basin | basins], wips, dones, current) do
    [prev_row_positions | _] = basin

    {current_remain, intersects} =
      Enum.split_with(current, fn positions ->
        positions -- prev_row_positions == positions
      end)

    {prev_row_positions, intersects}

    if intersects == [] do
      done_basin = List.flatten(basin)
      check_row_basin(basins, wips, [done_basin | dones], current)
    else
      wip = [List.flatten(intersects) | basin]
      check_row_basin(basins, [wip | wips], dones, current_remain)
    end
  end

  @doc """
  Example
  iex> input = \"""
  ...> 2199943210
  ...> 3987894921
  ...> 9856789892
  ...> 8767896789
  ...> 9899965678
  ...> \"""
  iex> Day9.part2_2(input)
  1134
  """

  def part2_2(input) do
    metric = parse_file(input, split_by: "\n", map_by: &map_by/1)

    lowest_points = find_lowest_points(metric)

    column_slants =
      metric
      |> flip_metric
      |> Enum.map(&find_slants/1)
      |> Enum.with_index()
      |> Enum.map(fn {row, x_index} ->
        Enum.map(row, &{&1, x_index})
      end)
      |> flip_metric
      |> List.flatten()

    row_slants =
      Enum.map(metric, &find_slants/1)
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, y_index} ->
        Enum.map(row, &{&1, y_index})
      end)

    points =
      Enum.zip(row_slants, column_slants)
      |> Enum.flat_map(fn
        {{false, _}, {false, _}} -> []
        {{_, x}, {_, y}} -> [{x, y}]
      end)

    lowest_points
    |> Enum.map(fn {_, point} -> build_basin([point], points, []) end)
    |> Enum.map(&length/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp build_basin([], _, acc), do: acc

  defp build_basin([point | points], full_points, acc) do
    {curr_x, curr_y} = point

    new_points =
      [
        Enum.find(full_points, fn {x, y} -> x == curr_x && y == curr_y + 1 end),
        Enum.find(full_points, fn {x, y} -> x == curr_x && y == curr_y - 1 end),
        Enum.find(full_points, fn {x, y} -> x == curr_x - 1 && y == curr_y end),
        Enum.find(full_points, fn {x, y} -> x == curr_x + 1 && y == curr_y end)
      ]
      |> Enum.reject(&is_nil/1)

    build_basin(points ++ new_points, full_points -- [point | new_points], [point | acc])
  end

  defp find_slants(list), do: Enum.map(list, &(&1 < 9))

  defp find_lowest_points(metric) do
    column_low_points =
      metric
      |> flip_metric
      |> Enum.map(&find_low_points/1)
      |> flip_metric

    row_low_points = Enum.map(metric, &find_low_points/1)

    zip_metrics(row_low_points, column_low_points, [])
    |> Enum.with_index()
    |> Enum.map(fn {row, x_index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {pos, y_index} -> {pos, {x_index, y_index}} end)
    end)
    |> List.flatten()
    |> Enum.filter(fn
      {{true, true}, _} -> true
      _ -> false
    end)
  end

  defp zip_metrics([], [], acc), do: Enum.reverse(acc)

  defp zip_metrics([r | rs], [c | cs], acc) do
    row = Enum.zip([r, c])
    zip_metrics(rs, cs, [row | acc])
  end

  defp map_by(row) do
    row |> String.graphemes() |> Enum.map(&String.to_integer/1)
  end
end
