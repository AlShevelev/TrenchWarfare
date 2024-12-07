part of game_builders;

abstract interface class GameBuilder {
  int get humanIndex;

  String get mapFileName;

  int get dayNumber;

  Future<MapMetadata> getMetadata();

  Future<GameField> getGameField();

  GameFieldSettingsStorage getSettings();

  GameOverConditionsCalculator getGameOverConditions();

  Iterable<NationRecord> getPlayingNations();

  Map<Nation, Iterable<TroopTransferReadForSaving>> getTransfers();
}