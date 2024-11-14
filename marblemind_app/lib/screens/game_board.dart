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
  List<List<Cell>> _grid = List.generate(4, (i) => List.generate(4, (j) => Cell(marble: null)));
  String currentPlayer = 'X';
  bool gameOver = false;
  Timer? _turnTimer;
  int _turnTimeLeft = 30;


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
      _showGameOverDialog();  // Show a dialog if the game is over
      return;
    }

    // Check if the tapped cell is already occupied
    if (_grid[row][col].marble != null) {
      // If the tapped cell contains the current player's marble, allow counterclockwise movement
      if (_grid[row][col].marble == currentPlayer) {
        // Perform counterclockwise movement and check for win
        bool winDetected = GameLogic.moveMarbleCounterclockwise(_grid, row, col); 
        
        // Ensure UI is updated after the move
        setState(() {});
      
      if (winDetected) {
          gameOver = true;
          stopTurnTimer(this);
          _showWinnerDialog();
          return;
        }
      } else {
        // If the tapped cell contains the opponent's marble, do nothing
        return;
      }
    } else {
      // If the tapped cell is empty, place the current player's marble
      setState(() {
        _grid[row][col].marble = currentPlayer;
        // Check for winner or game over condition
        if (GameLogic.checkForWinner(_grid)) {
          gameOver = true;
          stopTurnTimer(this);
          _showWinnerDialog();
        } else {
          switchTurn();
        }
      });
    }
  }
  

  // Winner and game over check
  void _showGameOverDialog() {
    stopTurnTimer(this);
    showGameOverDialog(context);  // Using a dialog widget from dialogs.dart
  }

  void _showWinnerDialog() {
    stopTurnTimer(this);
    showWinnerDialog(context, currentPlayer);  // Using a dialog widget from dialogs.dart
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
            ),
          ],
        ),
      ),
    );
  }
}
