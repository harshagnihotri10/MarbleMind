import 'package:shared_preferences/shared_preferences.dart';

class StatsManager {
  int xWins = 0;
  int oWins = 0;
  int draws = 0;

  // Load the statistics from SharedPreferences
  Future<void> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    xWins = prefs.getInt('xWins') ?? 0;
    oWins = prefs.getInt('oWins') ?? 0;
    draws = prefs.getInt('draws') ?? 0;
  }

  // Save the statistics to SharedPreferences
  Future<void> saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('xWins', xWins);
    prefs.setInt('oWins', oWins);
    prefs.setInt('draws', draws);
  }

  // Update the stats based on the game result
  void updateStats(String result) async {
    if (result == 'X') {
      xWins++;
    } else if (result == 'O') {
      oWins++;
    } else {
      draws++;
    }

    await saveStats();
  }

  // Reset the statistics
  Future<void> resetStats() async {
    // Reset local variables
    xWins = 0;
    oWins = 0;
    draws = 0;

    await saveStats();
  }
}
