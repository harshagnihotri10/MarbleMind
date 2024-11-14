import '../models/cell.dart';

class GameLogic {
  // Function to move the marble in a counterclockwise direction
  static void moveMarbleCounterclockwise(
      List<List<Cell>> grid, int row, int col) {
    int directionIndex = 0; // Initial direction is up

    // Directions for counterclockwise movement: up, left, down, right
    List<List<int>> directions = [
      [-1, 0],  // up
      [0, -1],  // left
      [1, 0],   // down
      [0, 1]    // right
    ];

    for (int i = 0; i < 4; i++) {
      int newRow = row + directions[directionIndex][0];
      int newCol = col + directions[directionIndex][1];

      // Ensure the new position is within bounds of the grid (0-3)
      if (newRow >= 0 && newRow < 4 && newCol >= 0 && newCol < 4) {
        // Move the marble to the new position if it's empty
        if (grid[newRow][newCol].marble == null) {
          grid[newRow][newCol].marble = grid[row][col].marble;
          grid[row][col].marble = null; // Empty the old position
          break; // Exit the loop once the marble is moved
        }
      }

      // Update the direction to the next one in counterclockwise order
      directionIndex = (directionIndex + 1) % 4;
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
