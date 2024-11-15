import 'package:flutter/material.dart';
import '../models/cell.dart';

class GameGrid extends StatelessWidget {
  final List<List<Cell>> grid;
  final Function(int, int) onCellTap;
  final List<Cell> winningCells;

  const GameGrid({
    super.key,
    required this.grid,
    required this.onCellTap,
    required this.winningCells,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(4, (row) {
        return Row(
          children: List.generate(4, (col) {
            final cell = grid[row][col];
            final isWinningCell = winningCells.contains(cell); // Check if the cell is part of the winning linenningCell = winningCells.contains(cell);  // Check if the cell is part of the winning line

            return GestureDetector(
              onTap: () => onCellTap(row, col),
              child: Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isWinningCell
                      ? Theme.of(context).colorScheme.secondary // Highlight winning cells
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isWinningCell
                      ? [
                          BoxShadow(color: Theme.of(context).colorScheme.secondary, blurRadius: 10)
                        ] // Add a glow effect for winning cells
                      : [],
                ),
                child: Center(
                  child: Text(
                    cell.marble ?? '',
                    style: TextStyle(
                      fontSize: 24,
                      color: isWinningCell ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
