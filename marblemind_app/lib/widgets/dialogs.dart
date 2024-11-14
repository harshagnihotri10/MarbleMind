import 'package:flutter/material.dart';
import '../screens/game_board.dart';

// Dialog for game over
void showGameOverDialog(BuildContext context) {
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

// Dialog for declaring a winner
void showWinnerDialog(BuildContext context, String currentPlayer) {
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
