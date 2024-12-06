import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../models/cell.dart';

final Logger logger = Logger();

class SaveLoadManager {
  // Save the current game state
  Future<bool> saveGameState(
      List<List<Cell>> grid, String currentPlayer) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert game state to a JSON string.
      Map<String, dynamic> gameState = {
        'grid': grid
            .map((row) => row.map((cell) => cell.toJson()).toList())
            .toList(),
        'currentPlayer': currentPlayer,
      };

      // Convert the game state map to JSON string
      String gameStateJson = jsonEncode(gameState);

      // Save the game state with a key.
      await prefs.setString('saved_game_state', gameStateJson);
      logger.i('Game state saved successfully.');
      return true; // Indicating the save was successful.
    } catch (e) {
      logger.e("Error saving game state: $e");
      return false; // Indicating the save failed.
    }
  }

  // Load the saved game state 
  Future<Map<String, dynamic>?> loadGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Retrieve the saved game state as a JSON string
      String? gameStateJson = prefs.getString('saved_game_state');

      if (gameStateJson == null || gameStateJson.isEmpty) {
        logger.w("No saved game state found.");
        return null;
      }

      logger.i("Loaded game state: $gameStateJson");

      // Decode the JSON string back into a map
      Map<String, dynamic> gameState = jsonDecode(gameStateJson);

      // Reconstruct the grid from the saved state
      List<List<Cell>> grid = List.generate(
        4,
        (i) => List.generate(
          4,
          (j) {
            var marble = gameState['grid'][i][j];
            if (marble is Map<String, dynamic>) {
              return Cell.fromJson(marble); // Deserialize
            } else if (marble is Cell) {
              return marble; // Already a Cell object
            } else {
              logger.w(
                "Unexpected type for marble at grid[$i][$j]: $marble. Using default Cell.");
              return Cell.defaultCell(row: i, col: j); // Provide a fallback
            }
          },
        ),
      );

      logger.i('Game state loaded successfully.');

      // Return the loaded game state
      return {
        'grid': grid,
        'currentPlayer': gameState['currentPlayer'],
      };
    } catch (e, stacktrace) {
      logger.e("Error loading game state: $e", e, stacktrace);
      return null;
    }
  }

  // Clear the saved game state
  Future<void> clearGameState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('saved_game_state');
  }
}