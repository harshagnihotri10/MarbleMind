import 'package:flutter/material.dart';
import 'game_board.dart';  // Import the game screen file

void main() {
  runApp(MarbleMindApp());
}

class MarbleMindApp extends StatelessWidget {
  const MarbleMindApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MarbleMind Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameBoard(), // Set GameBoard as the home widget
    );
  }
}
