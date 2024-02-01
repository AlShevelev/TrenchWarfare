part of game_field_sm;

sealed class State {}

class Initial implements State {}

class ReadyForInput implements State {}

class WaitingForEndOfPath implements State {
  final GameFieldCell startPathCell;

  WaitingForEndOfPath(this.startPathCell);
}

class PathIsShown implements State {
  final Iterable<GameFieldCell> path;

  PathIsShown(this.path);
}

class MovingInProgress implements State { }