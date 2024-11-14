import 'package:flutter/material.dart';
import '../models/cell.dart';

class GameGrid extends StatelessWidget {
  final List<List<Cell>> grid;
  final Function(int, int) onCellTap;

  const GameGrid({super.key, required this.grid, required this.onCellTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
      ),
      itemCount: 16, // 4x4 grid = 16 items
      itemBuilder: (context, index) {
        int row = index ~/ 4;
        int col = index % 4;

        return GestureDetector(
          onTap: () => onCellTap(row, col),        
          child: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: grid[row][col].marble == null
                  ? Colors.white
                  : grid[row][col].marble == 'X'
                      ? Colors.blue
                      : Colors.red,
            ),
            child: Center(
              child: Text(
                grid[row][col].marble ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
