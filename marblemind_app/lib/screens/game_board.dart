import 'package:flutter/material.dart';
import 'dart:async';
import 'main_menu.dart';
import 'leaderboard.dart';
import '../models/cell.dart';
import '../widgets/game_grid.dart';
import '../widgets/dialogs.dart';
import '../utils/timer_utils.dart';
import '../utils/game_logic.dart';
import '../utils/stats_manager.dart';
import '../utils/save_load_manager.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  List<List<Cell>> _grid = List.generate(
      4, (i) => List.generate(4, (j) => Cell(marble: null, row: i, col: j)));
  String currentPlayer = 'X';
  bool gameOver = false;
  Timer? _turnTimer;
  int _turnTimeLeft = 30;
  List<Cell> winningCells = [];

  GameLogic gameLogic = GameLogic();
  StatsManager statsManager = StatsManager();
  SaveLoadManager saveLoadManager = SaveLoadManager();

  @override
  void initState() {
    super.initState();
    _loadStats();

    // Ensure _loadGameState runs after the widget tree is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGameState();
    });
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
        showWinnerDialog(context, winningPlayer, _resetGameState,
            _navigateToMainMenu); // Show the correct winning player's name
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

    setState(() {});      // Refresh UI after resetting stats
    startTurnTimer(this); // Restart the timer
  }

  // Method to Save Game State
  Future<void> _saveGameState() async {
  // Call saveGameState and check the result.
  bool saveSuccessful = await SaveLoadManager().saveGameState(_grid, currentPlayer);
  
  // Use the result to show the appropriate message.
  if (saveSuccessful) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Game Saved!'))
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save the game state.'))
    );
  }
}


  // Method to Load Game State
  Future<void> _loadGameState() async {
    try {
      Map<String, dynamic>? gameState = await SaveLoadManager().loadGameState();
      
      if (gameState != null) {
      // Update the UI with the loaded state
      setState(() {
        _grid = gameState['grid']; // Use the grid returned directly
        currentPlayer = gameState['currentPlayer'];
      });
      
        // Show a SnackBar indicating that the game has been successfully loaded
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Game Loaded!'),
          backgroundColor: Colors.green, // Green color for success
        ));
      } else {
        // Show a SnackBar indicating no saved game was found
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No Saved Game Found!'),
          backgroundColor: Colors.red, // Red color for error
        ));
      }
    } catch (e, stacktrace) {
      logger.e("Error loading game state: $e", e, stacktrace);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to Load Game State!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _loadStats() async {
    await statsManager.loadStats();
    setState(() {}); // Trigger a UI update after loading stats
  }

  // Update the stats based on the result
  void _updateStats(String result) {
    statsManager.updateStats(result);
    statsManager.saveStats();
    setState(() {}); // Refresh UI to show updated stats
  }

  // Stats display section in the UI
  Widget _buildStatsDisplay() {
    return Text(
      'X Wins: ${statsManager.xWins} | O Wins: ${statsManager.oWins} | Draws: ${statsManager.draws}',
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  // Winner and game over check
  void _showGameOverDialog() {
    stopTurnTimer(this);
    showGameOverDialog(context, _resetGameState,
        _navigateToMainMenu); // Using a dialog widget from dialogs.dart
  }

  void _showWinnerDialog() {
    stopTurnTimer(this);
    showWinnerDialog(context, currentPlayer, _resetGameState,
        _navigateToMainMenu); // Using a dialog widget from dialogs.dart
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

      showWinnerDialog(
          context, winningPlayer, _resetGameState, _navigateToMainMenu);
    }
  }

  // Navigate to main menu or exit
  void _navigateToMainMenu() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainMenu()),
    );
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
            _buildStatsDisplay(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Save Button
                ElevatedButton(
                  onPressed: () {
                    showConfirmationDialog(
                      context,
                      'Confirm Save',
                      'Do you want to save the current game state?',
                      _saveGameState,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: Text('Save Game'),
                ),
                const SizedBox(width: 20),
                // Load Button
                ElevatedButton(
                  onPressed: () {
                    showConfirmationDialog(
                      context,
                      'Confirm Load',
                      'Do you want to load the previously saved game state?',
                      _loadGameState,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: Text('Load Game'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildStatsDisplay(),
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
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              Leaderboard()), // Navigate to Leaderboard
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
                  child: Text('Leaderboard'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
