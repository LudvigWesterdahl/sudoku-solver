defmodule Util do

  def tuple_to_string(tup) do
    tup |> Tuple.to_list() |> Enum.join(", ")
  end

  def enum_to_string(enum) do
    middle = enum
      |> Enum.to_list()
      |> Enum.join(", ")

    "[" <> middle <> "]"
  end

  def list_len(a) when not is_list(a) do
    {:error, :invalid_argument}
  end

  def list_len([]) do
    0
  end

  def list_len([head | tail]) do
    do_list_len([head | tail], 0)
  end

  defp do_list_len([], a) do
    a
  end

  defp do_list_len([_ | tail], a) do
    do_list_len(tail, a + 1)
  end


  def range(from, to) when is_number(from) and is_number(to) do
    do_range(from, to, [])
  end

  def range(_, _) do
    {:error, :invalid_arguments}
  end

  defp do_range(from, to, list) when from - 1 == to do
    list
  end

  defp do_range(from, to, list) do
    new_list = [to | list]
    do_range(from, to - 1, new_list)
  end

  def positive(list) when is_list(list) do
    do_positive(list, [])
  end

  defp do_positive([], a) do
    Enum.reverse(a)
  end

  defp do_positive(list, a) do
    [head | tail] = list

    if head > 0 do
      do_positive(tail, [head | a])
    else
      do_positive(tail, a)
    end
  end


  def list_to_string(list) do
    "[" <> do_list_to_string(list)
  end

  defp do_list_to_string([]) do
    ""
  end

  defp do_list_to_string([head | tail]) do
    head_string = case head do
      [_ | _] -> "[" <> do_list_to_string(head)
      [] -> "[]"
      num -> to_string(num)
    end

    tail_string = case tail do
      [_ | _] -> ", " <> do_list_to_string(tail)
      [] -> "]"
    end

    head_string <> tail_string
  end
end

board = Sudoku.get_board()
# board, row_index, col_index, num
set_all = [
  {0, 1, 6},
  {0, 3, 4},
  {0, 5, 3},
  {0, 7, 7},
  {1, 0, 7},
  {1, 1, 5},
  {1, 2, 1},
  {2, 5, 2},
  {3, 5, 9},
  {3, 6, 8},
  {3, 7, 6},
  {4, 4, 8},
  {4, 5, 1},
  {4, 8, 7},
  {5, 0, 4},
  {5, 4, 5},
  {6, 1, 1},
  {6, 7, 8},
  {7, 1, 2},
  {7, 6, 1},
  {8, 0, 6},
  {8, 1, 3},
  {8, 6, 5},
]

board = Enum.reduce(set_all, board, fn {row_index, col_index, num}, b_acc ->
  Sudoku.set(b_acc, row_index, col_index, num)
end)
#board = Sudoku.create_solvable_board()
Sudoku.print_board(board)
board = Sudoku.solve(board, true, 10)
Sudoku.print_board(board)