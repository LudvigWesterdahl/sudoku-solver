defmodule Sudoku do

  # Primitives

  def get_board() do
    get_board([])
  end

  defp get_board(a) do
    if length(a) == 81 do
      a
    else
      get_board([Enum.to_list(1..9) | a])
    end
  end

  # DEPRECATED
  def get_candidates(board) do
    f = get_single_candidates(board)
    Enum.with_index(board)
      |> Enum.map(f)
  end

  # DEPRECATED
  def get_single_candidates(board) do
    fn {v, i} ->
      if is_number(v) do
        [v]
      end

      row_index = div(i, 9)
      col_index = rem(i, 9)
      row = get_row(board, row_index)
      col = get_col(board, col_index)
      square = get_square_for(board, row_index, col_index)

      combined = row ++ col ++ square
      Enum.to_list(1..9)
        |> Enum.filter(fn v -> v not in combined end)
    end
  end

  def get_square(board, square_index) do
    get_square(board, div(square_index, 3), rem(square_index, 3))
  end

  def set_square(board, square_index, square) do
    set_square(board, div(square_index, 3), rem(square_index, 3), square)
  end

  def get_square(board, row_index, col_index) do
    get_square_for(board, row_index * 3, col_index * 3)
  end

  def set_square(board, row_index, col_index, square) do
    start_index = 9 * 3 * row_index + 3 * col_index

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

  def get_square_for(board, index) do
    row_index = div(index, 9)
    col_index = rem(index, 9)

    get_square_for(board, row_index, col_index)
  end

  def get_square_for(board, row_index, col_index) do
    r = div(row_index, 3)
    c = div(col_index, 3)

    start_index = 9 * 3 * r + 3 * c

    Enum.slice(board, start_index, 3)
    ++ Enum.slice(board, start_index + 9, 3)
    ++ Enum.slice(board, start_index + 18, 3)
  end

  def set_square_for(board, row_index, col_index, square) do
    r = div(row_index, 3)
    c = div(col_index, 3)

    set_square(board, r, c, square)
  end

  def get_row(board, row_index) do
    Enum.slice(board, 9 * row_index, 9)
  end

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

  def get_col(board, col_index) do
    Enum.drop(board, col_index)
      |> Enum.take_every(9)
  end

  def set_col(board, col_index, col) do
    indexes = Enum.to_list(0..8)
      |> Enum.map(fn i -> i * 9 + col_index end)

    Enum.with_index(board)
      |> Enum.map(fn {c, i} ->
        if i in indexes do
          Enum.at(col, div(i - col_index, 9))
        else
          c
        end
      end)
  end

  def set(board, row_index, col_index, num) do
    i = 9 * row_index + col_index
    board = List.replace_at(board, i, num)

    square = get_square_for(board, row_index, col_index)
    |> Enum.map(fn c ->
      if is_number(c) do
        c
      else
        List.delete(c, num)
      end
    end)
    board = set_square_for(board, row_index, col_index, square)

    row = get_row(board, row_index)
    |> Enum.map(fn c ->
      if is_number(c) do
        c
      else
        List.delete(c, num)
      end
    end)
    board = set_row(board, row_index, row)


    col = get_col(board, col_index)
    |> Enum.map(fn c ->
      if is_number(c) do
        c
      else
        List.delete(c, num)
      end
    end)
    board = set_col(board, col_index, col)
    #IO.inspect(col)
    board
  end

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

  def print_square(board, row_index, col_index) do
    IO.puts("Row: " <> to_string(row_index) <> ", Col: " <> to_string(col_index))
    square = get_square(board, row_index, col_index)
    Enum.to_list(0..2)
    |> Enum.each(fn r ->
      Enum.to_list(0..2)
      |> Enum.each(fn c ->
        v = Enum.at(square, r * 3 + c)
        if is_number(v) do
          IO.write(v)
        else
          IO.write("[" <> Enum.join(v, ", ") <> "]")
        end
        IO.write(", ")
      end)
      IO.write("\n")
    end)
  end

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

  # Functions

  def get_all_squares() do
    Enum.to_list(0..8)
    |> Enum.map(fn i -> {div(i, 3), rem(i, 3)} end)
  end

  def indexes_of_duplicates(lists, dup, num) do
    duplicates = Enum.reduce(Enum.with_index(lists), [], fn {list, i}, acc ->
      if num in list do
        [i | acc]
      else
        acc
      end
    end)

    if length(duplicates) == dup do
      duplicates
    else
      []
    end
  end

  def same_duplicates(lists, nums) do
    duplicates = Enum.map(nums, fn num ->
      indexes_of_duplicates(lists, length(nums), num)
    end)

    if length(hd(duplicates)) == 0 do
      []
    end

    if Enum.all?(duplicates, fn d -> d == hd(duplicates) end) do
      hd(duplicates)
    else
      []
    end
  end

  def combinations([head | []]) do
    [[head], []]
  end

  def combinations([head | tail]) do

    perms = combinations(tail)
    added = Enum.map(perms, fn p -> p ++ [head] end)

    perms ++ added
  end

  def combinations(size, [head | tail]) do
    Enum.filter(combinations([head | tail]), fn c ->
      length(c) == size
    end)
  end

  def print(name, value) do
    IO.puts(name <> "=" <> to_string(value))
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

  def get_all(board, fun) do
    Enum.to_list(0..8)
    |> Enum.map(fn i -> fun.(board, i) end)
    |> Enum.with_index()
  end

  def for_all_rows(board, mapper) do
    for_all(board, &Sudoku.get_row/2, &Sudoku.set_row/3, mapper)
  end

  def for_all_cols(board, mapper) do
    for_all(board, &Sudoku.get_col/2, &Sudoku.set_col/3, mapper)
  end

  def for_all_squares(board, mapper) do
    for_all(board, &Sudoku.get_square/2, &Sudoku.set_square/3, mapper)
  end

  def cell_combinations(size) do
    combinations(size, Enum.to_list(1..9))
  end

  def contains_list?(list, another) do
    another -- list == []
  end


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

  def modify_hidden(board, size, fun) do
    # For every combination, COMB.
    #   If COMB is inside exactly len(COMB) many cells then replace those cells with COMB.

    # 1. Get indexes of cells which contain COMB.
    # 2. Check length of them, ensure they are size long.
    # 3. Replace those cells with COMB using those indexes.

    fun.(board, fn container, i ->
      comb_indexes = cell_combinations(size)
                     |> Enum.map(fn comb ->
        indexes = Enum.with_index(container)
                  |> Enum.reduce([], fn {cell, cell_index}, acc ->

          if (not is_number(cell)) and contains_list?(cell, comb) do
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
        replace_at_all(acc_container, indexes, Enum.sort(comb))
      end)
    end)
  end

  def action_hidden(board, size) do
    modify_hidden(board, size, &Sudoku.for_all_rows/2)
    |> modify_hidden(size, &Sudoku.for_all_cols/2)
    |> modify_hidden(size, &Sudoku.for_all_squares/2)
  end

  def modify_visible(board, size, fun) do
    fun.(board, fn container, i ->
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

      comb_indexes_filtered = Enum.filter(comb_indexes, fn {comb, indexes} ->
        length(indexes) == size
      end)

      Enum.reduce(comb_indexes_filtered, container, fn {comb, indexes}, acc_container ->
        remove_from_all(acc_container, indexes, Enum.sort(comb))
      end)
    end)
  end

  def action_visible(board, 1) do
    single_indexes = Enum.with_index(board)
                     |> Enum.reduce([], fn {cell, cell_index}, indexes ->
      if is_number(cell) or length(cell) != 1 do
        indexes
      else
        [head | tail] = cell
        indexes ++ [{head, cell_index}]
      end
    end)

    Enum.reduce(single_indexes, board, fn {cell_num, cell_index}, b_acc ->
      set(b_acc, div(cell_index, 9), rem(cell_index, 9), cell_num)
    end)
  end

  def action_visible(board, size) when size != 1 do
    modify_visible(board, size, &Sudoku.for_all_rows/2)
    |> modify_visible(size, &Sudoku.for_all_cols/2)
    |> modify_visible(size, &Sudoku.for_all_squares/2)
  end



  def solve(board, interactive, max_count) do
    do_solve(board, interactive, max_count, 0)
  end

  def solve(board, interactive) do
    do_solve(board, interactive, -1, 0)
  end

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
      new_board = Enum.to_list(1..4)
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

  def create_solvable_board() do
    IO.puts("The cells are entered row by row.")
    IO.puts("Enter a number (1-9), S if no more numbers to input (start solve early) or just <enter> to continue.")
    do_create_solvable_board(get_board(), 0)
  end

  def do_create_solvable_board(board, index) do
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
          new_board = set(board, div(index, 9), rem(index, 9), num)
          do_create_solvable_board(new_board, index + 1)
      end
    end
  end
end