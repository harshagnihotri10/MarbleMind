import 'package:flutter/material.dart';
import 'dart:async';

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

  // Flag to check if the game is over
  bool gameOver = false;

  // Directions for counterclockwise movement: up, left, down, right
  List<List<int>> directions = [
    [-1, 0],  // Move up (row - 1, same column)
    [0, -1],  // Move left (same row, column - 1)
    [1, 0],   // Move down (row + 1, same column)
    [0, 1],   // Move right (same row, column + 1)
  ];

  Timer? _turnTimer;
  int _turnTimeLeft = 30;


  // Function to start timer
  void _startTurnTimer() {
    if (_turnTimer != null && _turnTimer!.isActive) {
    _turnTimer!.cancel(); // Cancel the existing timer if it's running
    }

    _turnTimeLeft = 30;  // Reset the timer to 30 seconds for each turn
    _turnTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_turnTimeLeft > 0) {
        setState(() {
         _turnTimeLeft--;
        }); 
        } else {
          // Timer ran out, switch turn automatically
          _switchTurn();
          timer.cancel();
        }
      });
  }

  // Function to stop timer
  void _stopTurnTimer() {
    if (_turnTimer != null) {
      _turnTimer!.cancel();
    }
  }

  // Function to switch turns between players and start a new timer
  void _switchTurn() {
    setState(() {
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X'; // Switch the player
      _startTurnTimer();  // Start the timer for the next player
    });
  }

  // Function to handle tap on a cell
  void _handleCellTap(int row, int col) {
    // Check if the game is over
    if (gameOver) {
      _showGameOverDialog();  // Show a dialog if the game is over
      return;
    }

    // Check if the tapped cell is already occupied
    if (_grid[row][col].marble != null) {  
      // If the tapped cell contains the current player's marble, allow counterclockwise movement
      if (_grid[row][col].marble == currentPlayer) {
        _moveMarbleCounterclockwise(row, col);  // Move marble counterclockwise
      } else {
        // If the tapped cell contains the opponent's marble, do nothing
        return;
      }
    } else {
      // If the tapped cell is empty, place the current player's marble
      setState(() {
        _grid[row][col].marble = currentPlayer;
        // Check for winner or game over condition
        if (_checkForWinner()) {
          gameOver = true;
          _stopTurnTimer();
          _showWinnerDialog();
        } else {
          // Alternate turns between 'X' and 'O'
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
          _startTurnTimer();
        }
      });
    }
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

  // Function to check if there is a winner
  bool _checkForWinner() {
    // Check rows, columns, and diagonals for a winner
    for (int i = 0; i < 4; i++) {
      if (_grid[i][0].marble != null && _grid[i][0].marble == _grid[i][1].marble && _grid[i][1].marble == _grid[i][2].marble && _grid[i][2].marble == _grid[i][3].marble) {
        return true;
      }
      if (_grid[0][i].marble != null && _grid[0][i].marble == _grid[1][i].marble && _grid[1][i].marble == _grid[2][i].marble && _grid[2][i].marble == _grid[3][i].marble) {
        return true;
      }
    }
    if (_grid[0][0].marble != null && _grid[0][0].marble == _grid[1][1].marble && _grid[1][1].marble == _grid[2][2].marble && _grid[2][2].marble == _grid[3][3].marble) {
      return true;
    }
    if (_grid[0][3].marble != null && _grid[0][3].marble == _grid[1][2].marble && _grid[1][2].marble == _grid[2][1].marble && _grid[2][1].marble == _grid[3][0].marble) {
      return true;
    }
    return false;
  }

  // Function to show a dialog when the game is over
  void _showGameOverDialog() {
    _stopTurnTimer();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('The game is over!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to show a winner dialog
  void _showWinnerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('We Have a Winner!'),
          content: Text('$currentPlayer Wins!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
            Text('Time Left: $_turnTimeLeft seconds',  // Display the remaining time
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
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