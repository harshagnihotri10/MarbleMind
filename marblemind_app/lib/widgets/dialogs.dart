import 'package:flutter/material.dart';

/// Reusable Custom Dialog Widget
class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;

  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    required this.actions,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 16,
          ),
        ),
      ),
      actions: actions,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}

/// Show Game Over Dialog
void showGameOverDialog(
    BuildContext context, Function resetGame, Function navigateToMainMenu) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: 'Game Over',
        message: 'The game is over!',
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text('Play Again',
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Consistent shape
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            onPressed: () {
              showConfirmationDialog(
                context,
                'Confirmation',
                'Are you sure you want to quit the game?',
                navigateToMainMenu,
              );
            },
            child: const Text(
              'Quit',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

/// Show Winner Dialog
void showWinnerDialog(
    BuildContext context, String currentPlayer, Function resetGame, Function navigateToMainMenu) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: 'We Have a Winner!',
        message: '$currentPlayer Wins!',
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Consistent shape
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text('Play Again',
              style: TextStyle(color: Theme.of(context).primaryColor)
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Consistent shape
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            onPressed: () {
              showConfirmationDialog(
                context,
                'Confirmation',
                'Are you sure you want to quit the game?',
                navigateToMainMenu,
              );
            },
            child: const Text(
              'Quit',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

/// Show Draw Dialog
void showDrawDialog(
    BuildContext context, Function resetGame, Function navigateToMainMenu) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CustomDialog(
        title: 'Game Draw!',
        message: 'The game ended in a draw. No winner this time!',
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Consistent shape
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text(
              'Restart',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Consistent shape
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            onPressed: () {
              showConfirmationDialog(
                context,
                'Confirmation',
                'Are you sure you want to go to the Main Menu?',
                navigateToMainMenu,
              );
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

// Show Confirmation Dialog
void showConfirmationDialog(BuildContext context, String title, String content, Function onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 16,
          ),
        ),
        actions: [
          // "No" button with outlined style and secondary color
          OutlinedButton(
            onPressed: () =>
                Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red, width: 1.5), // Border color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
            ), // Close the dialog without action
            child: Row(
              children: [
                const Icon(Icons.close,
                    color: Colors.red), // Add icon for better clarity
                const SizedBox(width: 6),
                const Text('No', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              onConfirm(); // Execute the confirmed action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor, // Button color
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold), // Bold text
              elevation: 5, // Elevation for depth effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.check,
                    color: Colors.white), // Add icon for better clarity
                const SizedBox(width: 6),
                const Text('Yes'),
              ],
            ),
          ),
        ],
      );
    },
  );
}

/// Show Custom Information Dialog (for Save/Load Success or Failure)
void showCustomDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: title,
        message: message,
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK',
                style: TextStyle(color: Colors.green)),
          ),
        ],
      );
    },
  );
}