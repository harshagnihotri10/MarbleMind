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
        brightness: Brightness.light, // Keep light mode
        primaryColor: const Color(0xFFB39DDB), // Soft Lavender (Player X color)
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFFFAB91),  // Soft Peach (Player O color)
          surface: const Color(0xFFFCE4EC), // Pastel Pink background
        ),
        scaffoldBackgroundColor: const Color(0xFFFCE4EC), // Pastel Pink for the app background

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF4A4A4A)), // Dark gray for readability
          bodyMedium: TextStyle(color: Color(0xFF757575)), // Light gray for secondary text
          titleMedium: TextStyle(color: Color(0xFF4A4A4A), fontSize: 24, fontWeight: FontWeight.bold), // Titles
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFAED581), // Soft Mint for the App Bar
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF81D4FA), // Soft Blue for buttons
          disabledColor: Color(0xFFE0E0E0), // Light Gray for disabled buttons
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF81D4FA), // Soft Blue for buttons
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: const Color(0xFFFFF9C4), // Soft Yellow for dialog backgrounds
        ),
      ),
      home: const GradientBackground(child: GameBoard()),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFCE4EC), // Pastel Pink
            Color(0xFFFFF9C4), // Soft Yellow
            Color(0xFFAED581), // Soft Mint
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}