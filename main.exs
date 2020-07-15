pre_board_1 = [
  {1, 2, 9},
  {1, 4, 2},
  {1, 5, 3},
  {2, 1, 1},
  {2, 2, 3},
  {2, 5, 5},
  {3, 0, 9},
  {3, 3, 3},
  {4, 1, 4},
  {4, 4, 8},
  {4, 7, 1},
  {4, 8, 7},
  {5, 3, 7},
  {5, 5, 2},
  {5, 8, 4},
  {6, 3, 2},
  {6, 4, 4},
  {6, 5, 7},
  {6, 7, 5},
  {6, 8, 1},
  {7, 1, 2},
  {7, 2, 5},
  {7, 7, 7},
  {8, 0, 7},
  {8, 1, 3},
  {8, 3, 8},
  {8, 7, 4},
  {8, 8, 6},
]

solution_board_1 = [
  5, 6, 4, 9, 7, 8, 1, 2, 3,
  8, 7, 9, 1, 2, 3, 4, 6, 5,
  2, 1, 3, 4, 6, 5, 7, 9, 8,
  9, 5, 7, 3, 1, 4, 6, 8, 2,
  3, 4, 2, 5, 8, 6, 9, 1, 7,
  1, 8, 6, 7, 9, 2, 5, 3, 4,
  6, 9, 8, 2, 4, 7, 3, 5, 1,
  4, 2, 5, 6, 3, 1, 8, 7, 9,
  7, 3, 1, 8, 5, 9, 2, 4, 6
]

pre_board_2 = [
  {0, 0, 4},
  {0, 2, 3},
  {1, 2, 8},
  {1, 5, 3},
  {1, 6, 2},
  {2, 1, 7},
  {2, 3, 8},
  {2, 4, 1},
  {2, 7, 9},
  {3, 0, 1},
  {3, 3, 9},
  {3, 5, 6},
  {3, 7, 8},
  {3, 8, 7},
  {4, 2, 7},
  {4, 8, 2},
  {5, 1, 2},
  {6, 0, 7},
  {6, 2, 4},
  {6, 7, 3},
  {7, 4, 4},
  {7, 5, 7},
  {8, 0, 8},
  {8, 3, 6},
  {8, 4, 3},
  {8, 8, 1},
]

solution_board_2 = [
  4, 9, 3, 7, 6, 2, 8, 1, 5,
  5, 1, 8, 4, 9, 3, 2, 7, 6,
  2, 7, 6, 8, 1, 5, 4, 9, 3,
  1, 4, 5, 9, 2, 6, 3, 8, 7,
  3, 8, 7, 1, 5, 4, 9, 6, 2,
  6, 2, 9, 3, 7, 8, 1, 5, 4,
  7, 6, 4, 2, 8, 1, 5, 3, 9,
  9, 3, 1, 5, 4, 7, 6, 2, 8,
  8, 5, 2, 6, 3, 9, 7, 4, 1
]

pre_board_3 = [
  {0, 0, 2},
  {0, 2, 7},
  {0, 3, 1},
  {0, 4, 9},
  {0, 6, 3},
  {0, 8, 4},
  {1, 0, 3},
  {1, 4, 5},
  {1, 5, 8},
  {1, 7, 2},
  {1, 8, 6},
  {2, 0, 9},
  {2, 1, 6},
  {2, 4, 2},
  {3, 6, 8},
  {3, 7, 9},
  {4, 3, 4},
  {4, 4, 7},
  {4, 5, 9},
  {4, 8, 5},
  {5, 0, 6},
  {5, 3, 8},
  {5, 5, 2},
  {6, 0, 5},
  {6, 5, 3},
  {6, 7, 1},
  {7, 4, 4},
  {7, 8, 9},
  {8, 2, 2},
  {8, 3, 9},
  {8, 4, 8},
  {8, 5, 7},
]

solution_board_3 = [
  2, 8, 7, 1, 9, 6, 3, 5, 4,
  3, 1, 4, 7, 5, 8, 9, 2, 6,
  9, 6, 5, 3, 2, 4, 1, 7, 8,
  4, 7, 3, 6, 1, 5, 8, 9, 2,
  8, 2, 1, 4, 7, 9, 6, 3, 5,
  6, 5, 9, 8, 3, 2, 7, 4, 1,
  5, 9, 8, 2, 6, 3, 4, 1, 7,
  7, 3, 6, 5, 4, 1, 2, 8, 9,
  1, 4, 2, 9, 8, 7, 5, 6, 3]

# Creating the boards.
board = Sudoku.get_board()

board_1 = Enum.reduce(pre_board_1, board, fn {row_index, col_index, num}, b_acc ->
  Sudoku.set(b_acc, 9 * row_index + col_index, num)
end)

board_2 = Enum.reduce(pre_board_2, board, fn {row_index, col_index, num}, b_acc ->
  Sudoku.set(b_acc, 9 * row_index + col_index, num)
end)

board_3 = Enum.reduce(pre_board_3, board, fn {row_index, col_index, num}, b_acc ->
  Sudoku.set(b_acc, 9 * row_index + col_index, num)
end)

# Solving the boards.

#Sudoku.print_board(board_1)
board_1 = Sudoku.solve(board_1, true)
#Sudoku.print_board(board_1)

#Sudoku.print_board(board_2)
board_2 = Sudoku.solve(board_2, true)
#Sudoku.print_board(board_2)

#Sudoku.print_board(board_3)
board_3 = Sudoku.solve(board_3, true)
#Sudoku.print_board(board_3)

# Ensures the boards are correctly solved.
IO.puts(if board_1 == solution_board_1 do "Successfully solved board 1!" else "Failed to solve board 1." end)
IO.puts(if board_2 == solution_board_2 do "Successfully solved board 2!" else "Failed to solve board 2." end)
IO.puts(if board_3 == solution_board_3 do "Successfully solved board 3!" else "Failed to solve board 3." end)

Sudoku.create_solvable_board()
|> Sudoku.solve(true, 200)
|> Sudoku.print_board()
