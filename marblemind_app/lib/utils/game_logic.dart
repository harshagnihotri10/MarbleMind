import '../models/cell.dart';

class GameLogic {
  // Function to shift all marbles counterclockwise in the entire grid
  void shiftAllMarblesCounterclockwise(List<List<Cell>> grid, int excludeRow, int excludeCol) {
    // Directions for counterclockwise movement (up, left, down, right)
    List<List<int>> directions = [
      [-1, 0],  // up
      [0, -1],  // left
      [1, 0],   // down
      [0, 1]    // right
    ];

    List<Cell> marbles = [];
    
    // Collect all the marbles in the grid excluding the one placed in the current turn
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        if (grid[row][col].marble != null && (row != excludeRow || col != excludeCol)) {
          marbles.add(grid[row][col]);
        }
      }
    }

    // Perform counterclockwise shift for all marbles
    for (int i = 0; i < marbles.length; i++) {
      // Get the current position of the marble
      int currentRow = marbles[i].row;
      int currentCol = marbles[i].col;

      // Find the next position for the marble
      for (int j = 0; j < 4; j++) {
        int newRow = currentRow + directions[j][0];
        int newCol = currentCol + directions[j][1];

        // Check if new position is within bounds
        if (newRow >= 0 && newRow < 4 && newCol >= 0 && newCol < 4) {
          // Move the marble to the new position if it's empty
          if (grid[newRow][newCol].marble == null) {
            grid[newRow][newCol].marble = marbles[i].marble;
            grid[currentRow][currentCol].marble = null; // Empty the old position
            break;
          }
        }
      }
    }
  }

  // Function to check if there's a winner; returns true if a winner is found
  static bool checkForWinner(List<List<Cell>> grid) {
    // Check rows, columns, and diagonals for a winner
    if (getWinningCells(grid).isNotEmpty) {
      return true;
    }
    return false;
  }

  // Function to check if there is a draw
  static bool checkForDraw(List<List<Cell>> grid) {
    // If there is a winner, it's not a draw
    if (checkForWinner(grid)) {
      return false;
    }

    // Check if all cells are filled
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        if (grid[row][col].marble == null) {
          // If there's at least one empty cell, it's not a draw
          return false;
        }
      }
    }
    
    // If all cells are filled and no winner, it's a draw
    return true;
  }

  // Returns the player who won, or null if there's no winner
static String? getWinningPlayer(List<List<Cell>> grid) {
  // Check horizontal and vertical lines
  for (int i = 0; i < 4; i++) {
    if (grid[i][0].marble != null &&
        grid[i][0].marble == grid[i][1].marble &&
        grid[i][1].marble == grid[i][2].marble &&
        grid[i][2].marble == grid[i][3].marble) {
      return grid[i][0].marble; // Return the player who won
    }
    if (grid[0][i].marble != null &&
        grid[0][i].marble == grid[1][i].marble &&
        grid[1][i].marble == grid[2][i].marble &&
        grid[2][i].marble == grid[3][i].marble) {
      return grid[0][i].marble;
    }
  }

  // Check diagonals
  if (grid[0][0].marble != null &&
      grid[0][0].marble == grid[1][1].marble &&
      grid[1][1].marble == grid[2][2].marble &&
      grid[2][2].marble == grid[3][3].marble) {
    return grid[0][0].marble;
  }
  if (grid[0][3].marble != null &&
      grid[0][3].marble == grid[1][2].marble &&
      grid[1][2].marble == grid[2][1].marble &&
      grid[2][1].marble == grid[3][0].marble) {
    return grid[0][3].marble;
  }

  return null; // No winner
}

  // Function to check if there is a winner
  static List<Cell> getWinningCells(List<List<Cell>> grid) {
    // Check rows, columns, and diagonals for a winner
    List<Cell> winningCells = [];

     // Check horizontal and vertical lines
    for (int i = 0; i < 4; i++) {
      if (grid[i][0].marble != null &&
          grid[i][0].marble == grid[i][1].marble &&
          grid[i][1].marble == grid[i][2].marble &&
          grid[i][2].marble == grid[i][3].marble) {
        winningCells = [grid[i][0], grid[i][1], grid[i][2], grid[i][3]];  // Add winning cells
        return winningCells;
      }
      if (grid[0][i].marble != null &&
          grid[0][i].marble == grid[1][i].marble &&
          grid[1][i].marble == grid[2][i].marble &&
          grid[2][i].marble == grid[3][i].marble) {
        winningCells = [grid[0][i], grid[1][i], grid[2][i], grid[3][i]];  // Add winning cells
        return winningCells;
      }
    }

    if (grid[0][0].marble != null &&
        grid[0][0].marble == grid[1][1].marble &&
        grid[1][1].marble == grid[2][2].marble &&
        grid[2][2].marble == grid[3][3].marble) {
      winningCells = [grid[0][0], grid[1][1], grid[2][2], grid[3][3]];
      return winningCells;
    }
    if (grid[0][3].marble != null &&
        grid[0][3].marble == grid[1][2].marble &&
        grid[1][2].marble == grid[2][1].marble &&
        grid[2][1].marble == grid[3][0].marble) {
      winningCells = [grid[0][3], grid[1][2], grid[2][1], grid[3][0]];
      return winningCells;
    }

    return winningCells;  // Return empty if no winner
  }
}
