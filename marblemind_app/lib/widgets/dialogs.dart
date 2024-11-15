import 'package:flutter/material.dart';


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

void showDrawDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,  // Prevent dialog from closing on tap outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Game Draw!'),
        content: const Text(
          'The game ended in a draw. No winner this time!',
          style: TextStyle(fontSize: 18),
        ),
        actions: <Widget>[
          // Button to restart the game
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  // Close the dialog
              Navigator.of(context).pop();  // Go back to the main game screen
              // You can add code here to reset the game state if needed
            },
            child: const Text(
              'Restart',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
          // Button to go back to the main menu
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  // Close the dialog
              Navigator.of(context).pop();  // Go back to main menu (if applicable)
              // Implement navigation to the main menu if you have one
            },
            child: const Text(
              'Main Menu',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
      );
    },
  );
}