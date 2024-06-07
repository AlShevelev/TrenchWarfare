part of player_ai;

class PeacefulPlayerAi extends PlayerAi {
  final GameFieldRead _gameField;

  PeacefulPlayerAi(this._gameField, super.player);

  @override
  void start() {
    final influences = InfluenceMapRepresentation()..calculate(_gameField);
  }
}