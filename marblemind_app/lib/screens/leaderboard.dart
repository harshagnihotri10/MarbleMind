import 'package:flutter/material.dart';
import '../utils/stats_manager.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  LeaderboardState createState() => LeaderboardState();
}

class LeaderboardState extends State<Leaderboard> {
  final StatsManager statsManager = StatsManager();

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  // Asynchronously load stats
  Future<void> _loadStats() async {
    await statsManager.loadStats();
    setState(() {}); // Refresh state after loading stats
  }

  // Reset leaderboard stats to zero
  void _resetStats() {
    statsManager.resetStats();
    setState(() {}); // Save the reset stats
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Reset Leaderboard'),
                    content: const Text('Are you sure you want to reset the leaderboard?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: const Text('Reset'),
                        onPressed: () {
                          _resetStats();
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Leaderboard',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            _buildStatsCard('X Wins', statsManager.xWins),
            const SizedBox(height: 10),
            _buildStatsCard('O Wins', statsManager.oWins),
            const SizedBox(height: 10),
            _buildStatsCard('Draws', statsManager.draws),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper function to build a card for stats display
  Widget _buildStatsCard(String label, int value) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: Padding(
        padding: const EdgeInsets.all(10.0), // Added padding for better spacing
        child: ListTile(
          title: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: Text(
            value.toString(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}
