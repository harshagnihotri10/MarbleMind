import 'package:flutter/material.dart';


// Dialog for game over
void showGameOverDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Game Over',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),  // Accent color for title
        ),
        content: Text('The game is over!',
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color), // Text color from theme
        ),
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
        title: Text('We Have a Winner!',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary), // Accent color for title
        ),
        content: Text('$currentPlayer Wins!',
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color), // Text color from theme
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK',
            style: TextStyle(color: Theme.of(context).primaryColor), // Primary color for button text
            ),
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
        title: Text('Game Draw!',
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),  
        ),
        content: Text(
          'The game ended in a draw. No winner this time!',
          style: TextStyle(fontSize: 18,
          color: Theme.of(context).textTheme.bodyLarge?.color, // Text color from theme
          ),
        ),
        actions: <Widget>[
          // Button to restart the game
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  // Close the dialog
              Navigator.of(context).pop();  // Go back to the main game screen
              // You can add code here to reset the game state if needed
            },
            child: Text(
              'Restart',
              style: TextStyle(color: Theme.of(context).primaryColor,  // Primary color for button text
                fontSize: 16,),
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