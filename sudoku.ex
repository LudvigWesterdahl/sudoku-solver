defmodule Util do
  @moduledoc """
  Module containing utility functions.
  """

  @doc """
  Returns true if a list contains all elements of another list and false otherwise.

  ## Parameters

    - list: The list to check.
    - another: The elements to check for containment in list.

  ## Examples

    iex> contains_list?([1,2,3,4,5], [4,1,2])
    true

    iex> contains_list?([1,2,3,4,5], [1,6])
    false
  """
  def contains_list?(list, another) do
    another -- list == []
  end

  @doc """
  Replaces all values at the indexes in list with val. This function works like List.replace_at/3
  for all indexes with the same value.

  ## Parameters

    - list: The list to replace in.
    - indexes: The indexes in the list to replace at.
    - val: The value to insert at the specified indexes.

  ## Examples

    iex> replace_at_all([1, 2, 4, 8, 16], [0, 3], 90)
    [90, 2, 4, 90, 16]

    iex> replace_at_all([1, 2, 3], [1, 5], 90)
    [1, 90, 3]
  """
  def replace_at_all(list, indexes, val) do
    Enum.with_index(list)
    |> Enum.map(fn {item, index} ->
      if index in indexes do
        val
      else
        item
      end
    end)
  end

  @doc """
  Removes elements from each element in a list except at some given indexes.

  ## Parameters

    - list: The list to remove from.
    - except_indexes: The indexes to ignore.
    - values: The values to remove from each element in list.

  ## Examples

    iex> remove_from_all([[1, 2, 3], [1, 2, 3]], [1], [1, 3])
    [[2], [1, 2, 3]]

    iex> remove_from_all([[1, 2, 3], [1, 2, 3], [1, 2, 3], [1, 2, 3]], [0, 3], [1, 5])
    [[1, 2, 3], [2, 3], [2, 3], [1, 2, 3]]
  """
  def remove_from_all(list, except_indexes, values) do
    Enum.with_index(list)
    |> Enum.map(fn {item, index} ->
      if index in except_indexes or not is_list(item) do
        item
      else
        item -- values
      end
    end)
  end

  @doc """
  Returns all combinations of the items in the given list in no defined order. Note, the examples show
  order, but the returned values do not.

  ## Parameters

    - [head | tail]: The elements to create the combinations from.

  ## Examples

    iex> combinations([])
    [[]]

    iex> combinations([1])
    [[], [1]]

    iex> combinations([1,2,3])
    [[], [1], [2], [3], [1, 2], [1, 3], [2, 3], [1, 2, 3]]
  """
  def combinations([]) do
    [[]]
  end

  @doc """
  Returns all combinations of the items in the given list in no defined order. Note, the examples show
  order, but the returned values do not.

  ## Parameters

    - [head | tail]: The elements to create the combinations from.

  ## Examples

    iex> combinations([])
    [[]]

    iex> combinations([1])
    [[], [1]]

    iex> combinations([1,2,3])
    [[], [1], [2], [3], [1, 2], [1, 3], [2, 3], [1, 2, 3]]
  """
  def combinations([head | tail]) do

    perms = combinations(tail)
    added = Enum.map(perms, fn p -> p ++ [head] end)

    perms ++ added
  end

  @doc """
  Returns all combinations of a given length.

  ## Parameters

    - length: The non-negative length of the combinations.
    - list: The elements to create the combinations from.

  ## Examples

    iex> combinations(1, [])
    []

    iex> combinations(1, [1, 2, 3])
    [[1], [2], [3]]

    iex> combinations(2, [1,2,3])
    [[1, 2], [1, 3], [2, 3]]
  """
  def combinations(length, list) when length >= 0 do
    Enum.filter(combinations(list), fn c ->
      length(c) == length
    end)
  end

  @doc """
  Prints the name and the value formatted like name=value.

  ## Parameters

    - name: The name of the variable.
    - value: The value of the variable.
  """
  def print(name, value) do
    IO.puts(name <> "=" <> to_string(value))
  end
end

defmodule Sudoku do
  @moduledoc """
  Module to solve a sudoku puzzle.
  """

  @doc """
  Returns a new fully populated sudoku puzzle board.
  """
  def get_board() do
    do_get_board([])
  end

  @doc """
  Implementation for Sudoku.get_board/0.

  ## Parameters

    - board: The sudoku board.
  """
  defp do_get_board(board) do
    if length(board) == 81 do
      board
    else
      do_get_board([Enum.to_list(1..9) | board])
    end
  end

#  def get_square(board, row_index, col_index) do
#    get_square_for(board, row_index * 3, col_index * 3)
#  end

#  def get_square_for(board, index) do
#    row_index = div(index, 9)
#    col_index = rem(index, 9)
#
#    get_square_for(board, row_index, col_index)
#  end

  @doc"""
  Returns the index of the row given the index of a cell.

  ## Parameters

    - cell_index: The index of the cell (0-80).

  ## Examples

    iex> to_row_index(0)
    0

    iex> to_row_index(8)
    0

    iex> to_row_index(9)
    1

    iex> to_row_index(80)
    8
  """
  defp to_row_index(cell_index) do
    div(cell_index, 9)
  end

  @doc """
  Returns the index of the column given the index of a cell.

  ## Parameters

    - cell_index: The index of the cell (0-80).

  ## Examples

    iex> to_column_index(0)
    0

    iex> to_column_index(8)
    8

    iex> to_column_index(9)
    0

    iex> to_column_index(80)
    8
  """
  defp to_column_index(cell_index) do
    rem(cell_index, 9)
  end

  @doc """
  Returns the index of the square given the index of a cell.

  ## Parameters

    - cell_index: The index of the cell (0-80).

  ## Examples

    iex> to_column_index(0)
    0

    iex> to_column_index(8)
    8

    iex> to_column_index(9)
    0

    iex> to_column_index(80)
    8
  """
  def to_square_index(cell_index) do
    r = to_row_index(cell_index) |> div(3)
    c = to_column_index(cell_index) |> div(3)
    3 * r + c
  end

  @doc """
  Returns the row given at the given index.

  ## Parameters

    - row_index: The index of the row (0-8) top to bottom.
  """
  def get_row(board, row_index) do
    Enum.slice(board, 9 * row_index, 9)
  end

  @doc """
  Replaces the row at the given index.

  ## Parameters

    - row_index: The index of the row (0-8) top to bottom.
  """
  def set_row(board, row_index, row) do
    start_index = 9 * row_index

    indexes = Enum.to_list(0..8)
              |> Enum.map(fn i -> i + start_index end)

    Enum.with_index(board)
    |> Enum.map(fn {c, i} ->
      if i in indexes do
        Enum.at(row, i - start_index)
      else
        c
      end
    end)
  end

  @doc """
  Returns the column at the given index.

  ## Parameters

    - column_index: The index of the column (0-8) left to right.
  """
  def get_col(board, column_index) do
    Enum.drop(board, column_index)
    |> Enum.take_every(9)
  end

  @doc """
  Replaces the column at the given index.

  ## Parameters

    - board: The sudoku board.
    - row_index: The index of the column (0-8) top to bottom.
    - column: The new column.
  """
  def set_col(board, col_index, column) do
    indexes = Enum.to_list(0..8)
              |> Enum.map(fn i -> i * 9 + col_index end)

    Enum.with_index(board)
    |> Enum.map(fn {c, i} ->
      if i in indexes do
        Enum.at(column, div(i - col_index, 9))
      else
        c
      end
    end)
  end

  @doc """
  Returns the square at the given index.

  ## Parameters

    - board: The sudoku board.
    - square_index: The index of the square from left to right, 0 to 8.

  ## Examples

    iex> get_square(board, 0) # Gets the top left (first) square.

    iex> get_square(board, 4) # Gets the middle square.

    iex> get_square(board, 8) # Gets the bottom right (last) square
  """
  def get_square(board, square_index) do
    #get_square_for(board, 3 * div(square_index, 3), 3 * rem(square_index, 3))
    r = div(square_index, 3)
    c = rem(square_index, 3)

    start_index = 9 * 3 * r + 3 * c

    Enum.slice(board, start_index, 3)
    ++ Enum.slice(board, start_index + 9, 3)
    ++ Enum.slice(board, start_index + 18, 3)
  end

#  def get_square_for(board, row_index, col_index) do
#    r = div(row_index, 3)
#    c = div(col_index, 3)
#
#    start_index = 9 * 3 * r + 3 * c
#
#    Enum.slice(board, start_index, 3)
#    ++ Enum.slice(board, start_index + 9, 3)
#    ++ Enum.slice(board, start_index + 18, 3)
#  end

  @doc """
  Replaces the row at the given index.

  ## Parameters

    - row_index: The index of the row (0-8) top to bottom.
  """
  def set_square(board, square_index, square) do
    # TODO: Improve this?
    start_index = 9 * 3 * div(square_index, 3) + 3 * rem(square_index, 3)

    indexes = [0, 1, 2, 9, 10, 11, 18, 19, 20]
              |> Enum.map(fn i -> i + start_index end)

    Enum.with_index(board)
    |> Enum.map(fn {c, i} ->
      if i in indexes do
        Enum.at(square, div(i - start_index, 3) + rem(i - start_index, 3))
      else
        c
      end
    end)
  end



#  def set_square_OLD_OLD_OLD(board, row_index, col_index, square) do
#    start_index = 9 * 3 * row_index + 3 * col_index
#
#    indexes = [0, 1, 2, 9, 10, 11, 18, 19, 20]
#              |> Enum.map(fn i -> i + start_index end)
#
#    Enum.with_index(board)
#      |> Enum.map(fn {c, i} ->
#        if i in indexes do
#          Enum.at(square, div(i - start_index, 3) + rem(i - start_index, 3))
#        else
#          c
#        end
#      end)
#  end



#  def set_square_for(board, row_index, col_index, square) do
#    r = div(row_index, 3)
#    c = div(col_index, 3)
#
#    #set_square(board, r,  c, square)
#    set_square(board, 3 * r + c, square)
#  end

  @doc """
  Sets a number at the given index on the board and updates all possibilities across the board.

  ## Parameters

    - board: The sudoku board.
    - cell_index: The index of the cell to set.
    - num: The number to set in that call.
  """
  def set(board, cell_index, num) do
    board = List.replace_at(board, cell_index, num)

    square = get_square(board, to_square_index(cell_index))
             |> Enum.map(fn c ->
      if is_number(c) do
        c
      else
        List.delete(c, num)
      end
    end)
    board = set_square(board, to_square_index(cell_index), square)

    row = get_row(board, to_row_index(cell_index))
          |> Enum.map(fn c ->
      if is_number(c) do
        c
      else
        List.delete(c, num)
      end
    end)
    board = set_row(board, to_row_index(cell_index), row)

    col = get_col(board, to_column_index(cell_index))
          |> Enum.map(fn c ->
      if is_number(c) do
        c
      else
        List.delete(c, num)
      end
    end)
    board = set_col(board, to_column_index(cell_index), col)
    board
  end

#  def set(board, row_index, col_index, num) do
#    i = 9 * row_index + col_index
#    board = List.replace_at(board, i, num)
#
#    square = get_square_for(board, row_index, col_index)
#             |> Enum.map(fn c ->
#      if is_number(c) do
#        c
#      else
#        List.delete(c, num)
#      end
#    end)
#    board = set_square_for(board, row_index, col_index, square)
#
#    row = get_row(board, row_index)
#          |> Enum.map(fn c ->
#      if is_number(c) do
#        c
#      else
#        List.delete(c, num)
#      end
#    end)
#    board = set_row(board, row_index, row)
#
#    col = get_col(board, col_index)
#          |> Enum.map(fn c ->
#      if is_number(c) do
#        c
#      else
#        List.delete(c, num)
#      end
#    end)
#    board = set_col(board, col_index, col)
#    #IO.inspect(col)
#    board
#  end



  @doc """
  Returns true if the board is solved and false otherwise.

  ## Parameters

    - board: The sudoku board.
  """
  def is_solved?(board) do
    Enum.to_list(1..9)
      |> Enum.map(fn i -> get_row(board, i - 1) end)
      |> Enum.all?(fn row -> Enum.to_list(1..9) == Enum.sort(row) end)
    and
    Enum.to_list(1..9)
    |> Enum.map(fn i -> get_col(board, i - 1) end)
    |> Enum.all?(fn col -> Enum.to_list(1..9) == Enum.sort(col) end)
    and
    Enum.to_list(1..9)
    |> Enum.map(fn i -> get_square(board, i - 1) end)
    |> Enum.all?(fn square -> Enum.to_list(1..9) == Enum.sort(square) end)
  end

#  def get_all_squares() do
#    Enum.to_list(0..8)
#    |> Enum.map(fn i -> {div(i, 3), rem(i, 3)} end)
#  end

#  def indexes_of_duplicates(lists, dup, num) do
#    duplicates = Enum.reduce(Enum.with_index(lists), [], fn {list, i}, acc ->
#      if num in list do
#        [i | acc]
#      else
#        acc
#      end
#    end)
#
#    if length(duplicates) == dup do
#      duplicates
#    else
#      []
#    end
#  end

#  def same_duplicates(lists, nums) do
#    duplicates = Enum.map(nums, fn num ->
#      indexes_of_duplicates(lists, length(nums), num)
#    end)
#
#    if length(hd(duplicates)) == 0 do
#      []
#    end
#
#    if Enum.all?(duplicates, fn d -> d == hd(duplicates) end) do
#      hd(duplicates)
#    else
#      []
#    end
#  end


  @doc """
  Iterates over the board and calls the function fun with the arguments, board and index from 0 to 8
  and returns a list of all fun returns wrapped in index.

  ## Parameters

    - board: The sudoku board.
    - fun: The function to retrieve from the board given an index.
  """
  def get_all(board, fun) do
    Enum.to_list(0..8)
    |> Enum.map(fn i -> fun.(board, i) end)
    |> Enum.with_index()
  end

  @doc """
  Returns the modified board.

  ## Parameters

    - board: The sudoku board
    - getter: Function to retrieve a row, column or square (container)
    - setter: Function to set the container given the board, index, container
    - mapper: Function to transform container taking the container, index.
  """
  def for_all(board, getter, setter, mapper) do
    get_all(board, getter)
    |> Enum.map(fn {container, i} -> {mapper.(container, i), i} end)
    |> Enum.reduce(board, fn {container, i}, b -> setter.(b, i, container) end)
  end

  @doc """
  Iterates over all rows on the given board and replaces the rows using the mapper function.

  ## Parameters

    - board: The sudoku board.
    - mapper: The mapper function taking a board and an index.
  """
  def for_all_rows(board, mapper) do
    for_all(board, &Sudoku.get_row/2, &Sudoku.set_row/3, mapper)
  end

  @doc """
  Iterates over all columns on the given board and replaces the rows using the mapper function.

  ## Parameters

    - board: The sudoku board.
    - mapper: The mapper function taking a board and an index.
  """
  def for_all_columns(board, mapper) do
    for_all(board, &Sudoku.get_col/2, &Sudoku.set_col/3, mapper)
  end

  @doc """
  Iterates over all squares on the given board and replaces the rows using the mapper function.

  ## Parameters

    - board: The sudoku board.
    - mapper: The mapper function taking a board and an index.
  """
  def for_all_squares(board, mapper) do
    for_all(board, &Sudoku.get_square/2, &Sudoku.set_square/3, mapper)
  end

  @doc """
  Returns all combinations of a given length consisting of numbers from 1 to 9.

  ## Parameters
    - length: The length of the combinations.

  ## Examples

    iex> cell_combinations(1)
    [[1], [2], [3], [4], [5], [6], [7], [8], [9]]
  """
  def cell_combinations(length) do
    Util.combinations(length, Enum.to_list(1..9))
  end

  @doc """
  Performs the elimination of possibilities based on hidden combinations. For instance, if the numbers 1 and 3 are
  in the same two cells in a row. For instance, cell#1 contains 1, 3, 5 and cell#2 contains 1, 3, 7, 8 and the other
  cells in that row does not have a 1 or 3 in them as possibilities. Then, 1 and 3 has to be in those two cells
  and the other possibilities can be removed from those two cells. That means removing 5 from cell#1 and
  7,8 from cell#2. The example here used a size of 2 and works similarly for columns or squares.

  ## Parameters

    - board: The sudoku board.
    - size: The length of the combination of numbers.
  """
  def action_hidden(board, size) do
    modify_hidden(board, size, &Sudoku.for_all_rows/2)
    |> modify_hidden(size, &Sudoku.for_all_columns/2)
    |> modify_hidden(size, &Sudoku.for_all_squares/2)
  end

  @doc """
  Helper function for Sudoku.action_hidden/2 which performs the functionality on either, rows, columns or squares
  depending on fun, see Sudoku.action_hidden/2.

  ## Parameters

    - board: the sudoku board.
    - size: The length of the combination of numbers.
    - fun: A function that takes the board and a function to map the container and index to another board.

  ## Examples

    iex> Sudoku.modify_hidden(board, 2, &Sudoku_for_all_cols/2)
  """
  defp modify_hidden(board, size, fun) do
    # For every combination, COMB.
    #   If COMB is inside exactly len(COMB) many cells then replace those cells with COMB.

    # 1. Get indexes of cells which contain COMB.
    # 2. Check length of them, ensure they are size long.
    # 3. Replace those cells with COMB using those indexes.

    fun.(board, fn container, _ ->
      comb_indexes = cell_combinations(size)
                     |> Enum.map(fn comb ->
        indexes = Enum.with_index(container)
                  |> Enum.reduce([], fn {cell, cell_index}, acc ->

          if (not is_number(cell)) and Util.contains_list?(cell, comb) do
            acc ++ [cell_index]
          else
            acc
          end
        end)
        {comb, indexes}
      end)

      comb_indexes_filtered = Enum.filter(comb_indexes, fn {comb, indexes} ->
        length(indexes) == size
        and not (Enum.with_index(container)
                 |> Enum.any?(fn {cell, cell_index} ->
          if is_number(cell) or cell_index in indexes do
            false
          else
            Enum.any?(comb, fn comb_val -> comb_val in cell end)
          end
        end))
      end)

      Enum.reduce(comb_indexes_filtered, container, fn {comb, indexes}, acc_container ->
        Util.replace_at_all(acc_container, indexes, Enum.sort(comb))
      end)
    end)
  end

  @doc """
  Sets all single possibilities as the number in those cells. For instance, if a cell contains only the possibility
  5, then 5 has to be in that cell.

  ## Parameters
    - board: The sudoku board.
  """
  def action_visible(board, 1) do
    single_indexes = Enum.with_index(board)
                     |> Enum.reduce([], fn {cell, cell_index}, indexes ->
      if is_number(cell) or length(cell) != 1 do
        indexes
      else
        [head | _] = cell
        indexes ++ [{head, cell_index}]
      end
    end)

    Enum.reduce(single_indexes, board, fn {cell_num, cell_index}, b_acc ->
      #set(b_acc, div(cell_index, 9), rem(cell_index, 9), cell_num)
      set(b_acc, cell_index, cell_num)
    end)
  end

  @doc """
  Performs the elimination of possibilities based on visible combinations. For instance, if two cells in a row contains
  only the possibilities 1 and 3, then 1 and 3 cannot exist in any other cell. Thus, 1 and 3 can be removed from
  the possibilities in that row and also the square if those two cells are in the same square.
  The example here used a size of 2 and works similarly for columns.

  ## Parameters

    - board: The sudoku board.
    - size: The length of the combination of numbers.
  """
  def action_visible(board, size) when size != 1 do
    modify_visible(board, size, &Sudoku.for_all_rows/2)
    |> modify_visible(size, &Sudoku.for_all_columns/2)
    |> modify_visible(size, &Sudoku.for_all_squares/2)
  end

  @doc """
  Helper function for Sudoku.action_visible/2 which performs the functionality on either, rows, columns or squares
  depending on fun, see Sudoku.action_visible/2.

  ## Parameters

    - board: the sudoku board.
    - size: The length of the combination of numbers.
    - fun: A function that takes the board and a function to map the container and index to another board.

  ## Examples

    iex> Sudoku.modify_visible(board, 2, &Sudoku_for_all_cols/2)
  """
  defp modify_visible(board, size, fun) do
    fun.(board, fn container, _ ->
      comb_indexes = cell_combinations(size)
                     |> Enum.map(fn comb ->
        indexes = Enum.with_index(container)
                  |> Enum.reduce([], fn {cell, cell_index}, acc ->

          if (not is_number(cell)) and Enum.sort(cell) == Enum.sort(comb) do
            acc ++ [cell_index]
          else
            acc
          end
        end)
        {comb, indexes}
      end)

      comb_indexes_filtered = Enum.filter(comb_indexes, fn {_, indexes} ->
        length(indexes) == size
      end)

      Enum.reduce(comb_indexes_filtered, container, fn {comb, indexes}, acc_container ->
        Util.remove_from_all(acc_container, indexes, Enum.sort(comb))
      end)
    end)
  end

  @doc """
  Solves the sudoku board and returns the solved board.

  ## Parameters

    - board: The sudoku board to solve.
    - interactive: Boolean flag if solver should print information during.
  """
  def solve(board, interactive) do
    solve(board, interactive, -1)
  end

  @doc """
  Solves the sudoku board and returns the solved board.

  ## Parameters

    - board: The sudoku board to solve.
    - interactive: Boolean flag if solver should print information during.
    - max_count: The maximum number of loops to perform before giving up.
  """
  def solve(board, interactive, max_count) do
    do_solve(board, interactive, max_count, 0)
  end

  @doc """
  Implementation for Sudoku.solve/2 and Sudoko.solve/3.
  """
  defp do_solve(board, interactive, max_count, count) do
    if interactive do
      IO.puts("Round: " <> to_string(count))
    end

    if is_solved?(board) do
      if interactive do
        IO.puts("Solved at round: " <> to_string(count))
      end

      board
    else
      new_board = Enum.to_list(1..5)
                  |> Enum.reduce(board, fn size, b_acc ->
        action_hidden(b_acc, size)
        |> action_visible(size)
      end)

      if count == max_count do
        new_board
      else
        # Tail recursion
        do_solve(new_board, interactive, max_count, count + 1)
      end
    end
  end

  @doc """
  Prompts the user to enter the sudoku cells and returns the finished board.
  """
  def create_solvable_board() do
    IO.puts("The cells are entered row by row.")
    IO.puts("Enter a number (1-9), S if no more numbers to input (start solve early) or just <enter> to continue.")
    do_create_solvable_board(get_board(), 0)
  end

  @doc """
  Implementation for Sudoku.create_solvable_board/0.

  ## Parameters

    - board: The sudoku board being built.
    - index: The cell index to read the next value to.
  """
  defp do_create_solvable_board(board, index) do
    if index == 81 do
      board
    else
      c = String.trim(IO.gets("> "), "\n")
      cond do
        c == "S" ->
          board
        c == "" ->
          do_create_solvable_board(board, index + 1)
        {num, _} = Integer.parse(c) ->
          #new_board = set(board, div(index, 9), rem(index, 9), num)
          new_board = set(board, index, num)
          do_create_solvable_board(new_board, index + 1)
      end
    end
  end

  @doc """
  Helper function that returns a formatted string based on numbers and if they are in cell.

  ## Parameters
    - numbers: The numbers to format.
    - cell: The sudoku cell.

  ## Examples

    iex> Sudoku.format_numbers([1, 2, 3], [1, 2, 3, 4])
    "1 2 3"

    iex> Sudoku.format_numbers([4, 5, 6], [1, 3, 4, 6, 7, 9])
    "4   6"

    iex> Sudoku.format_numbers([7, 8, 9], [1, 2, 3, 4, 9])
    "    9"
  """
  def format_numbers(numbers, cell) do
    Enum.reduce(numbers, "", fn num, acc ->
      if num in cell do
        acc <> to_string(num) <> " "
      else
        acc <> "  "
      end
    end)
    |> String.slice(0..4)
  end

  @doc"""
  Prints the board to the console.

  ## Parameters

    - board: The sudoku board to print.
  """
  def print_board(board) do

    Enum.to_list(0..8)
    |> Enum.map(fn i -> get_row(board, i) end)
    |> Enum.each(fn row ->
      first = Enum.reduce(row, "", fn _, acc ->
        acc <> "--------- "
      end)

      second = Enum.reduce(row, "", fn cell, acc ->
        if is_number(cell) do
          acc <> "|       | "
        else
          acc <> "| " <> format_numbers([1,2,3], cell) <> " | "
        end
      end)

      third = Enum.reduce(row, "", fn cell, acc ->
        if is_number(cell) do
          acc <> "| = " <> to_string(cell) <> " = | "
        else
          acc <> "| " <> format_numbers([4,5,6], cell) <> " | "
        end
      end)

      fourth = Enum.reduce(row, "", fn cell, acc ->
        if is_number(cell) do
          acc <> "|       | "
        else
          acc <> "| " <> format_numbers([7,8,9], cell) <> " | "
        end
      end)

      fifth = Enum.reduce(row, "", fn _, acc ->
        acc <> "--------- "
      end)

      IO.puts(first)
      IO.puts(second)
      IO.puts(third)
      IO.puts(fourth)
      IO.puts(fifth)
    end)

    :ok
  end
end