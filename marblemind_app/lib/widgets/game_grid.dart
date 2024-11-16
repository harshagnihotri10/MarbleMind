import 'package:flutter/material.dart';
import '../models/cell.dart';

class GameGrid extends StatefulWidget {
  final List<List<Cell>> grid;
  final List<Cell> winningCells;
  final Function(int, int) onCellTap;

  const GameGrid({
    super.key,
    required this.grid,
    required this.winningCells,
    required this.onCellTap,
  });

  @override
  _GameGridState createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> {
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "4x4 Marble Grid Game",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 16, // 4x4 Grid
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemBuilder: (context, index) {
                int row = index ~/ 4;
                int col = index % 4;
                final cell = widget.grid[row][col];
                final isWinningCell = widget.winningCells.contains(cell);

                return GestureDetector(
                  onTap: () {
                    if (isAnimating) return;
                    widget.onCellTap(row, col);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isWinningCell
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isWinningCell
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                      boxShadow: isWinningCell
                          ? [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.5),
                                blurRadius: 8,
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(scale: animation, child: child);
                        },
                        child: cell.marble != null
                            ? Text(
                                cell.marble!,
                                key: ValueKey(cell.marble),
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: cell.marble == 'X'
                                      ? Colors.red
                                      : Colors.blue,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}