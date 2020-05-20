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
    IO.inspect(col)
    board
  end

  def is_solved?(board) do
    Enum.to_list(1..9)
      |> Enum.map(fn i -> get_row(board, i) end)
      |> Enum.all?(fn row -> Enum.to_list(1..9) == Enum.sort(row) end)
    and
    Enum.to_list(1..9)
    |> Enum.map(fn i -> get_col(board, i) end)
    |> Enum.all?(fn col -> Enum.to_list(1..9) == Enum.sort(col) end)
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
      first = Enum.reduce(row, "", fn cell, acc ->
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
          acc <> "| " <> format_numbers([6,7,8], cell) <> " | "
        end
      end)

      fifth = Enum.reduce(row, "", fn cell, acc ->
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


  def action_single(board) do
    indexes = get_all_squares()

    # Single in square
    final_board = Enum.reduce(indexes, board, fn {r, c}, b ->
      square = get_square(b, r, c)

      combs = combinations(1, Enum.to_list(1..9))
      comb_indexes = Enum.map(combs, fn [c1] ->
        comb_index = Enum.reduce(Enum.with_index(square), [], fn {c, i}, acc ->
          if [c1] == c do
            acc ++ [i]
          else
            acc
          end
        end)
        {[c1], comb_index}
      end)

      filtered = Enum.filter(comb_indexes, fn {c, c_indexes} ->
        length(c_indexes) == 1
      end)

      square = Enum.map(square, fn c ->
        if c in Enum.map(filtered, fn {c, c_indexes} -> c end) do
          [v] = c
          v
        else
          c
        end
      end)

      #IO.inspect(square)

      new_board = Enum.with_index(square)
      |> Enum.reduce(b, fn {cell, i}, b ->
        if is_number(cell) do
          start_index = 9 * 3 * r + 3 * c

          start_indexes = [0, 1, 2, 9, 10, 11, 18, 19, 20]
                    |> Enum.map(fn ti -> ti + start_index end)

          index = Enum.at(start_indexes, i)

          set(b, div(index, 9), rem(index, 9), cell)
        else
          b
        end
      end)

      new_board
      end)

    final_board
  end

  def print(name, value) do
    IO.puts(name <> "=" <> to_string(value))
  end

  def action_hidden_single(board) do

  end



end

# Use tail recursion