part of player_ai;

abstract class PlayerAi {
  @protected
  final PlayerInput _player;

  PlayerAi(this._player);

  void start();
}