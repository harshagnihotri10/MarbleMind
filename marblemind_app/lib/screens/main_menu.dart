import 'package:flutter/material.dart';
import 'game_board.dart';
import 'dart:io';


class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MarbleMind Game Hub'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the game board screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameBoard()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Start New Game', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Show game rules in a dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Game Rules'),
                      content: const Text(
                        'Welcome to MarbleMind!\n\n'
                        '1. The game is played on a 4x4 grid.\n'
                        '2. Players take turns moving marbles counterclockwise.\n'
                        '3. The goal is to align a specific pattern of marbles to win.\n'
                        '4. Have fun and strategize your moves!',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
              ),
              child: const Text('View Rules', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Exit the app
                exit(0);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Exit', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
