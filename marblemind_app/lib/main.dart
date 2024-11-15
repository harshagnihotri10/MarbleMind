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
        primaryColor: const Color(0xFF616161), // Neutral Gray for Player X color
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF455A64), // Dark Gray for Player O color
          surface: const Color(0xFFEEEEEE), // Light Gray for app background
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Off-White for the app background

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF212121)), // Dark Gray for readability
          bodyMedium: TextStyle(color: Color(0xFF757575)), // Light Gray for secondary text
          titleMedium: TextStyle(color: Color(0xFF212121), fontSize: 24, fontWeight: FontWeight.bold), // Titles
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFAED581), // Dark Gray for App Bar
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF616161), // Neutral Gray for buttons
          disabledColor: Color(0xFFE0E0E0), // Light Gray for disabled buttons
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF616161), // Neutral Gray for buttons
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white, // Clean White for dialog backgrounds
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
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
            Color(0xFFECEFF1), // Light Gray
            Color(0xFFCFD8DC), // Soft Gray-Blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}