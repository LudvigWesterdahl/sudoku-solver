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

import IO
puts(Util.tuple_to_string(Util.list_len(3)))
puts(Util.list_len(Enum.to_list(1..25)))
puts(Util.list_len([]))

puts(Util.enum_to_string(Util.range(-2, 5)))
puts(Util.tuple_to_string(Util.range([], 3)))

#[head | tail] = [1,2,3,-5,3,-20,9]
#puts(head)

puts(Util.enum_to_string(Util.positive([1,2,3,-5,3,-20,9])))

#a = gets("Give me a number: ")
#{num, _} = Integer.parse(a)
#puts(num * 5)

#puts(Util.enum_to_string(Sudoku.get_board()))
#puts(Util.enum_to_string([[1,2,3], [1,2,3]]))

IO.puts("---------------------")
board = Sudoku.get_board()
#board = Sudoku.set(board, 0, 1, 3)
#board = Sudoku.set(board, 1, 4, 5)
#board = List.replace_at(board, 0, [4])
#board = Sudoku.action_single(board)
#board = Sudoku.for_all(board, &Sudoku.get_row/2, &Sudoku.set_row/3, fn row, i -> List.replace_at(row, 0, [i + 1]) end)
board = Sudoku.for_all_squares(board, fn row, i -> List.replace_at(row, 0, [i + 1]) end)
board = Sudoku.action_single(board)
board = List.replace_at(board, 54, [1, 2, 3, 7, 8])
board = List.replace_at(board, 57, [1, 2, 3, 8, 7])

#IO.inspect(board)
Sudoku.print_board(board)

#c = Sudoku.action_hidden_single([1,2,3])
board = Sudoku.action_hidden_single(board)

#IO.inspect(Enum.at(board, 54))

