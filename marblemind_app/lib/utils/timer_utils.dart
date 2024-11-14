import 'dart:async';
import '../screens/game_board.dart';

void startTurnTimer(GameBoardState gameBoardState) {
  // Cancel existing timer if it's running
  gameBoardState.turnTimer?.cancel();

  // Set the time left using the setter
  gameBoardState.turnTimeLeft = 30;  

  // Create and start the timer
  gameBoardState.setTurnTimer(Timer.periodic(Duration(seconds: 1), (timer) {
    if (gameBoardState.turnTimeLeft > 0) {
      gameBoardState.turnTimeLeft--;  // Decrease the remaining time
    } else {
      gameBoardState.switchTurn();
      gameBoardState.turnTimer?.cancel();  // Stop the timer when time runs out
      startTurnTimer(gameBoardState);
    }
  }));
}

void stopTurnTimer(GameBoardState gameBoardState) {
  // Cancel the timer if it's active
  gameBoardState.turnTimer?.cancel();  // Use the getter to cancel the timer
}

