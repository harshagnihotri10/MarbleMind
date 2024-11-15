import 'package:flutter/material.dart';
import 'dart:async';
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
  List<List<Cell>> _grid = List.generate(
      4, (i) => List.generate(4, (j) => Cell(marble: null, row: i, col: j)));
  String currentPlayer = 'X';
  bool gameOver = false;
  Timer? _turnTimer;
  int _turnTimeLeft = 30;
  List<Cell> winningCells = [];

  GameLogic gameLogic = GameLogic();

  @override
  void initState() {
    super.initState();
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
        showWinnerDialog(context, winningPlayer); // Show the correct winning player's name
        } else if (GameLogic.checkForDraw(_grid)) {  // New Draw Condition Check
        gameOver = true;
        stopTurnTimer(this);
        _showDrawDialog();  
        } else {
          // Change turn to the other player
          switchTurn();
      }    
    }
  }

  // Winner and game over check
  void _showGameOverDialog() {
    stopTurnTimer(this);
    showGameOverDialog(context); // Using a dialog widget from dialogs.dart
  }

  void _showWinnerDialog() {
    stopTurnTimer(this);
    showWinnerDialog(context, currentPlayer); // Using a dialog widget from dialogs.dart
  }

  // Method to Show Draw Dialog
  void _showDrawDialog() {
    stopTurnTimer(this);
    showDrawDialog(context);  // Using a dialog widget from dialogs.dart
  }

  void _highlightWinningCells() {
    String? winningPlayer = GameLogic.getWinningPlayer(_grid);
    if (winningPlayer != null) {
      // Highlight the winning cells
      List<Cell> winningCells = GameLogic.getWinningCells(_grid);
      if (winningCells.isNotEmpty) {
        setState(() {
          this.winningCells = winningCells; // Store the winning cells to be highlighted
        });
      }

      showWinnerDialog(context, winningPlayer); 
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
            Text('Current Player: $currentPlayer'),
            Text(
              'Time Left: $turnTimeLeft seconds',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            const SizedBox(height: 20),
            GameGrid(
              grid: _grid,
              onCellTap: _handleCellTap,
              winningCells: winningCells, // Pass the winning cells to GameGrid
            ),
          ],
        ),
      ),
    );
  }
}
