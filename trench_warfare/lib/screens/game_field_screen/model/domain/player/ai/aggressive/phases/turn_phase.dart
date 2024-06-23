part of aggressive_player_ai;

abstract interface class TurnPhase {
  @protected
  final PlayerInput _player;

  @protected
  final GameFieldRead _gameField;

  @protected
  final Nation _myNation;

  @protected
  final MoneyStorageRead _nationMoney;

  @protected
  final MapMetadataRead _metadata;

  TurnPhase(
    this._player,
    this._gameField,
    this._myNation,
    this._nationMoney,
    this._metadata,
  );

  Future<void> start();
}
