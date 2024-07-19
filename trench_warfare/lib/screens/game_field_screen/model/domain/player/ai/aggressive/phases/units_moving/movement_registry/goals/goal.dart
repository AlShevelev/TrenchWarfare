part of aggressive_player_ai;

abstract interface class Goal {
  bool isReachable();

  GameFieldCellRead getGoalCell();
}