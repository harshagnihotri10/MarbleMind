import 'package:flutter/material.dart';
import 'screens/game_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MarbleMind',
      theme: ThemeData(
        brightness: Brightness.light, // Set the theme to light mode to match background colors
        primaryColor: const Color(0xFF0077FF), // Blue Accent (for Player X)
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFFF4C4C),  // Red Accent (for Player O)
          surface: const Color(0xFFF4F6F9), // Light Gray background
        ),
        
        scaffoldBackgroundColor: const Color(0xFFF4F6F9), // Light background for the app

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF333333)), // Dark gray for primary text
          bodyMedium: TextStyle(color: Color(0xFF8E8E93)), // Secondary text (light gray)
          titleMedium: TextStyle(color: Color(0xFF333333), fontSize: 24, fontWeight: FontWeight.bold), // For titles
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C2F36), // Dark Gray for the App Bar
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF34C759), // Accent Green for active buttons
          disabledColor: Color(0xFFD1D1D6), // Light gray for disabled buttons
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: const Color(0xFF0077FF), // White text color for buttons
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: const Color(0xFFF4F6F9), // Light gray for dialog background
        ),
      ),
      home: const GameBoard(),
    );
  }
}
