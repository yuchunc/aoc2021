defmodule Day4 do
  @input_file "priv/day4.txt"

  @doc """
  Example
    iex> input = \"""
    ...> 7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
    ...>
    ...> 22 13 17 11  0
    ...>  8  2 23  4 24
    ...> 21  9 14 16  7
    ...>  6 10  3 18  5
    ...>  1 12 20 15 19
    ...>
    ...>  3 15  0  2 22
    ...>  9 18 13 17  5
    ...> 19  8  7 25 23
    ...> 20 11 10 24  4
    ...> 14 21 16 12  6
    ...>
    ...> 14 21 17 24  4
    ...> 10 16 15  9 19
    ...> 18  8 23 26 20
    ...> 22 11 13  6  5
    ...>  2  0 12  3  7
    ...> \"""
    iex> Day4.part1(input)
    4512
  """
  def part1(input \\ nil) do
    {draws, boards} =
      (input || File.read!(@input_file))
      |> input_parser

    compute_draws(draws, boards)
  end

  @doc """
  Example
    iex> input = \"""
    ...> 7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
    ...>
    ...> 22 13 17 11  0
    ...>  8  2 23  4 24
    ...> 21  9 14 16  7
    ...>  6 10  3 18  5
    ...>  1 12 20 15 19
    ...>
    ...>  3 15  0  2 22
    ...>  9 18 13 17  5
    ...> 19  8  7 25 23
    ...> 20 11 10 24  4
    ...> 14 21 16 12  6
    ...>
    ...> 14 21 17 24  4
    ...> 10 16 15  9 19
    ...> 18  8 23 26 20
    ...> 22 11 13  6  5
    ...>  2  0 12  3  7
    ...> \"""
    iex> Day4.part2(input)
    1924
  """
  def part2(input \\ nil) do
    {draws, boards} =
      (input || File.read!(@input_file))
      |> input_parser

    compute_draws_last(draws, boards)
  end

  defp compute_draws_last([draw | t], boards) do
    case traverse_boards_last(boards, draw, []) do
      {:found, board} ->
        board
        |> List.flatten()
        |> Enum.uniq()
        |> Enum.sum()
        |> Kernel.*(draw)

      boards_1 ->
        compute_draws_last(t, boards_1)
    end
  end

  defp traverse_boards_last([], _draw, acc), do: acc

  defp traverse_boards_last([board | t], draw, acc) do
    board_1 = Enum.map(board, &List.delete(&1, draw))

    case {[] in board_1, t == [], acc == []} do
      {true, true, true} -> {:found, board_1}
      {true, _, _} -> traverse_boards_last(t, draw, acc)
      _ -> traverse_boards_last(t, draw, [board_1 | acc])
    end
  end

  defp compute_draws([draw | t], boards) do
    case traverse_boards(boards, draw, []) do
      {:bingo, board} ->
        board
        |> List.flatten()
        |> Enum.uniq()
        |> Enum.sum()
        |> Kernel.*(draw)

      boards_1 ->
        compute_draws(t, boards_1)
    end
  end

  defp traverse_boards([], _, new_boards), do: new_boards

  defp traverse_boards([board | t], draw, acc) do
    board_1 = Enum.map(board, &List.delete(&1, draw))

    if [] in board_1 do
      {:bingo, board_1}
    else
      traverse_boards(t, draw, [board_1 | acc])
    end
  end

  defp input_parser(text_input) do
    [draws_txt | board_txts] =
      text_input
      |> String.split("\n\n", trim: true)

    draws =
      draws_txt
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards =
      board_txts
      |> Enum.map(&parse_board/1)

    {draws, boards}
  end

  defp parse_board(board_txt) do
    board =
      board_txt
      |> String.split("\n", trim: true)
      |> Enum.flat_map(&String.split(&1, " ", trim: true))
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(5)

    board_inverse =
      board
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    board ++ board_inverse
  end
end
