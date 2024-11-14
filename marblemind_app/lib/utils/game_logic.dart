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


  // Function to check if there is a winner
  static bool checkForWinner(List<List<Cell>> grid) {
    // Check rows, columns, and diagonals for a winner
    for (int i = 0; i < 4; i++) {
      if (grid[i][0].marble != null &&
          grid[i][0].marble == grid[i][1].marble &&
          grid[i][1].marble == grid[i][2].marble &&
          grid[i][2].marble == grid[i][3].marble) {
        return true;
      }
      if (grid[0][i].marble != null &&
          grid[0][i].marble == grid[1][i].marble &&
          grid[1][i].marble == grid[2][i].marble &&
          grid[2][i].marble == grid[3][i].marble) {
        return true;
      }
    }

    if (grid[0][0].marble != null &&
        grid[0][0].marble == grid[1][1].marble &&
        grid[1][1].marble == grid[2][2].marble &&
        grid[2][2].marble == grid[3][3].marble) {
      return true;
    }
    if (grid[0][3].marble != null &&
        grid[0][3].marble == grid[1][2].marble &&
        grid[1][2].marble == grid[2][1].marble &&
        grid[2][1].marble == grid[3][0].marble) {
      return true;
    }
    return false;
  }
}
