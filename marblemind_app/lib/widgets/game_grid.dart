import 'package:flutter/material.dart';
import '../models/cell.dart';

class GameGrid extends StatefulWidget {
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
  _GameGridState createState() => _GameGridState();
}

class _GameGridState extends State<GameGrid> with SingleTickerProviderStateMixin {
  late List<List<Cell>> grid;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    grid = widget.grid;

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Trigger the marble animation
  void animateMarble(int startRow, int startCol, int endRow, int endCol) {
    setState(() {
      isAnimating = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        String marble = grid[startRow][startCol].marble!;
        grid[startRow][startCol].marble = null;
        grid[endRow][endCol].marble = marble;
        isAnimating = false;
      });
    });
  }

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
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              children: List.generate(4, (row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (col) {
                    final cell = grid[row][col];
                    final isWinningCell = widget.winningCells.contains(cell);
                    return GestureDetector(
                      onTap: () {
                        if (isAnimating) return;
                        widget.onCellTap(row, col);
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isWinningCell
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.grey[300],
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
                                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                    blurRadius: 8,
                                  ),
                                ]
                              : [],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(scale: animation, child: child);
                          },
                          child: cell.marble != null
                              ? Center(
                                  key: ValueKey(cell.marble),
                                  child: Text(
                                    cell.marble!,
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: cell.marble == 'X' ? Colors.red : Colors.blue,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}