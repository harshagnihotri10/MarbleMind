import 'package:flutter/material.dart';

// Cell class to represent each grid cell
class Cell{
  String? marble; // Represents the player's marble ('X' or '0') or null if empty

  Cell({this.marble});
}

// Main game screen with a 4x4 grid
class GameBoard extends StatefulWidget {
  const GameBoard({super.key});
  
  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  // Initialize a 4x4 grid of cells
  List<List<Cell>> _grid = List.generate(
    4,
    (i) => List.generate(4, (j) => Cell(marble: null)),
  );

  // Variable to alternate turns between Player X and Player O
  String currentPlayer = 'X';

  // Directions for counterclockwise movement: up, left, down, right
  List<List<int>> directions = [
    [-1, 0],  // Move up (row - 1, same column)
    [0, -1],  // Move left (same row, column - 1)
    [1, 0],   // Move down (row + 1, same column)
    [0, 1],   // Move right (same row, column + 1)
  ];

  // Function to handle tap on a cell
  void _handleCellTap(int row, int col) {
    setState(() {
      // Check if there is a marble and it belongs to the current player
      if (_grid[row][col].marble == null) {
        _grid[row][col].marble = currentPlayer;
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';   // Switch turns between 'X' and 'O'
      } else {
        // Call the counterclockwise movement function
        _moveMarbleCounterclockwise(row, col);
      }
    });
  }

  // Function to move the marble in a counterclockwise direction
  void _moveMarbleCounterclockwise(int row, int col) {
    setState(() {
      int directionIndex = 0; // Initial direction is up

      // Loop to move the marble in the counterclockwise direction
      for (int i = 0; i < 4; i++) {
        int newRow = row + directions[directionIndex][0];
        int newCol = col + directions[directionIndex][1];

        // Ensure the new position is within bounds of the grid (0-3)
        if (newRow >= 0 && newRow < 4 && newCol >= 0 && newCol < 4) {
          // Move the marble to the new position if it's empty
          if (_grid[newRow][newCol].marble == null) {
            _grid[newRow][newCol].marble = _grid[row][col].marble;
            _grid[row][col].marble = null; // Empty the old position
            break; // Exit the loop once the marble is moved
          }
        }

        // Update the direction to the next one in counterclockwise order
        directionIndex = (directionIndex + 1) % 4;
      }
    });
  }

  // Function to build the game board UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MarbleMind'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Player: $currentPlayer'),
            const SizedBox(height: 20),
            // Create the 4x4 grid
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
              ),
              itemCount: 16, // 4x4 grid = 16 items
              itemBuilder: (context, index) {
                int row = index ~/ 4;
                int col = index % 4;

                return GestureDetector(
                  onTap: () => _handleCellTap(row, col),
                  child: Container(
                    margin: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: _grid[row][col].marble == null
                          ? Colors.white
                          : _grid[row][col].marble == 'X'
                              ? Colors.blue
                              : Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        _grid[row][col].marble ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          color:_grid[row][col].marble == 'X'
                              ? Colors.white
                              : Colors.white, // Set the text color (white for both)
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}