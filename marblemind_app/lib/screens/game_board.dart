import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'main_menu.dart';
import '../models/cell.dart';
import '../widgets/game_grid.dart';
import '../widgets/dialogs.dart';
import '../utils/timer_utils.dart';
import '../utils/game_logic.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  final List<List<Cell>> _grid = List.generate(
      4, (i) => List.generate(4, (j) => Cell(marble: null, row: i, col: j)));
  String currentPlayer = 'X';
  bool gameOver = false;
  Timer? _turnTimer;
  int _turnTimeLeft = 30;
  List<Cell> winningCells = [];

  GameLogic gameLogic = GameLogic();

  // Add variables for game stats
  int _xWins = 0;
  int _oWins = 0;
  int _draws = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  // Getters for turnTimeLeft
  Timer? get turnTimer => _turnTimer;
  int get turnTimeLeft => _turnTimeLeft;

  // Setter for turnTimeLeft
  set turnTimeLeft(int timeLeft) {
    setState(() {
      _turnTimeLeft = timeLeft;
    });
  }

  // Load the statistics from SharedPreferences
  void _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _xWins = prefs.getInt('xWins') ?? 0;
      _oWins = prefs.getInt('oWins') ?? 0;
      _draws = prefs.getInt('draws') ?? 0;
    });
  }

  // Save the statistics to SharedPreferences
  void _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('xWins', _xWins);
    prefs.setInt('oWins', _oWins);
    prefs.setInt('draws', _draws);
  }

  // Reset the game state
  void _resetGameState() {
    setState(() {
      for (var row in _grid) {
        for (var cell in row) {
          cell.marble = null;
        }
      }
      // Reset all cells
      currentPlayer = 'X'; // Reset the starting player
      gameOver = false; // Game is not over
      winningCells.clear(); // Clear any winning cells from the previous round
      _turnTimeLeft = 30; // Reset the timer to its original value
    });
    startTurnTimer(this); // Restart the timer
  }

  // Navigate to main menu or exit
  void _navigateToMainMenu() {
    Navigator.of(context).pushReplacement(

      MaterialPageRoute(builder: (context) => const MainMenu()),
      
    );
  }

  // Switch turn and reset the timer
  void switchTurn() {
    setState(() {
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    });
    startTurnTimer(this);
  }

  // Method to set a new turn timer
  void setTurnTimer(Timer? timer) {
    _turnTimer = timer;
  }

  // Handle cell taps
  void _handleCellTap(int row, int col) {
    if (gameOver) {
      _showGameOverDialog(); // Show a dialog if the game is over
      return;
    }

    // Check if the tapped cell is empty
    if (_grid[row][col].marble == null) {
      // Place the current player's marble on the empty cell
      setState(() {
        _grid[row][col].marble = currentPlayer;
      });

      // Trigger counterclockwise shift for all other marbles (excluding the newly placed marble)
      gameLogic.shiftAllMarblesCounterclockwise(_grid, row, col);

      // After shift, check for winner or game over condition
      String? winningPlayer = GameLogic.getWinningPlayer(_grid);
      if (winningPlayer != null) {
        gameOver = true;
        stopTurnTimer(this);
        _highlightWinningCells(); // Highlight the winning cells
        showWinnerDialog(context, winningPlayer,
            _resetGameState, _navigateToMainMenu); // Show the correct winning player's name
        _updateStats(winningPlayer);
      } else if (GameLogic.checkForDraw(_grid)) {
        // New Draw Condition Check
        gameOver = true;
        stopTurnTimer(this);
        _showDrawDialog();
        _updateStats('draw');
      } else {
        // Change turn to the other player
        switchTurn();
      }
    }
  }

  // Update the stats based on the result
  void _updateStats(String result) {
    if (result == 'X') {
      setState(() {
        _xWins++;
      });
    } else if (result == 'O') {
      setState(() {
        _oWins++;
      });
    } else {
      setState(() {
        _draws++;
      });
    }
    _saveStats(); // Save the updated stats
  }

  // Winner and game over check
  void _showGameOverDialog() {
    stopTurnTimer(this);
    showGameOverDialog(context, _resetGameState,
        _navigateToMainMenu); // Using a dialog widget from dialogs.dart
  }

  void _showWinnerDialog() {
    stopTurnTimer(this);
    showWinnerDialog(context, currentPlayer,
        _resetGameState, _navigateToMainMenu); // Using a dialog widget from dialogs.dart
  }

  // Method to Show Draw Dialog
  void _showDrawDialog() {
    stopTurnTimer(this);
    showDrawDialog(context, _resetGameState,
        _navigateToMainMenu); // Using a dialog widget from dialogs.dart
  }

  void _highlightWinningCells() {
    String? winningPlayer = GameLogic.getWinningPlayer(_grid);
    if (winningPlayer != null) {
      // Highlight the winning cells
      List<Cell> winningCells = GameLogic.getWinningCells(_grid);
      if (winningCells.isNotEmpty) {
        setState(() {
          this.winningCells =
              winningCells; // Store the winning cells to be highlighted
        });
      }

      showWinnerDialog(context, winningPlayer, _resetGameState, _navigateToMainMenu);
    }
  }

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
            Text(
              'Current Player: $currentPlayer',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Time Left: $turnTimeLeft seconds',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 20),
            GameGrid(
              grid: _grid,
              onCellTap: _handleCellTap,
              winningCells: winningCells, // Pass the winning cells to GameGrid
            ),
            const SizedBox(height: 20),
            // Stats Section
            Text('X Wins: $_xWins | O Wins: $_oWins | Draws: $_draws'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showConfirmationDialog(
                      context,
                      'Confirm Restart',
                      'Are you sure you want to restart the game?',
                      _resetGameState,
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .primaryColor, // Button background color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    elevation: 2, // Slight shadow for depth
                  ),
                  child: Text('Restart'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    showConfirmationDialog(
                        context, 
                        'Confirm Main Menu',
                        'Are you sure you want to go to the main menu?',
                        () {
                        _navigateToMainMenu();
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .primaryColor, // Button background color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    elevation: 2, // Slight shadow for depth
                  ),
                  child: Text('Main Menu'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
