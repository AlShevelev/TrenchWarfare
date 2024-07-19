part of aggressive_player_ai;

class MoveToTheCellGoal extends Goal {
  final GameFieldCellRead _cellToMove;

  MoveToTheCellGoal({required GameFieldCellRead cellToMove}) : _cellToMove = cellToMove;

  @override
  GameFieldCellRead getGoalCell() {
    // TODO: implement getGoalCell
    throw UnimplementedError();
  }

  @override
  bool isReachable() {
    // TODO: implement isReachable
    throw UnimplementedError();
  }
}