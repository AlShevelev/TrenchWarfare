sealed class GameFieldControlsState {}

class Invisible extends GameFieldControlsState {}

class Visible extends GameFieldControlsState {
  final int money;
  final int industryPoints;

  Visible({required this.money, required this.industryPoints});
}

