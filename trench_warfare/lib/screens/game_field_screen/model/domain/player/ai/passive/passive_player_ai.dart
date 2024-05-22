part of player_ai;

class PassivePlayerAi extends PlayerAi {
  PassivePlayerAi(super.player);

  @override
  void start() async {
    await Future.delayed(const Duration(seconds: 1));
    _player.onEndOfTurnButtonClick();
  }
}