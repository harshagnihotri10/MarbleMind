import 'package:flutter/material.dart';

class Cell{
  String? marble; // Represents the player's marble ('X' or '0') or null if empty

  Cell({this.marble});
}

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // Initialize a 4x4 grid of cells
  List<List<Cell>> _grid = List.generate(
    4,
    (_) => List.generate(4, (_) => Cell()),
  );

  // Variable to alternate turns between Player X and Player O
  String currentPlayer = 'X';

  // Function to handle tap on a cell
  void _handleCellTap(int row, int col) {
    setState(() {
      // Check if the cell is empty before placing a marble
      if (_grid[row][col].marble == null) {
        _grid[row][col].marble = currentPlayer;

        // Switch turns between 'X' and 'O'
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MarbleMind Game - 4x4 Grid'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 columns to match the 4x4 grid
          ),
          itemCount: 16, // Total cells (4 rows * 4 columns)
          itemBuilder: (context, index) {
            int row = index ~/ 4; // Calculate row number
            int col = index % 4;  // Calculate column number

            return GestureDetector(
              onTap: () => _handleCellTap(row, col),
              child: Container(
                margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    _grid[row][col].marble ?? '', // Display 'X', 'O', or empty
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _grid[row][col].marble == 'X' ? Colors.blue : Colors.red,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}