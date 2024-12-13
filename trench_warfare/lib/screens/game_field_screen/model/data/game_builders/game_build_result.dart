part of game_builders;

class GameBuildResult {
  final int humanIndex;

  final bool isGameLoaded;

  final String mapFileName;

  final MapMetadata metadata;

  final GameField gameField;

  final GameFieldSettingsStorage settings;

  final GameOverConditionsCalculator conditions;

  final List<NationRecord> playingNations;

  final List<int> nationsDayNumber;

  final Map<Nation, Iterable<TroopTransferReadForSaving>> transfers;

  final Map<Nation, MoneyStorage> money;

  GameBuildResult({
    required this.humanIndex,
    required this.isGameLoaded,
    required this.mapFileName,
    required this.nationsDayNumber,
    required this.metadata,
    required this.gameField,
    required this.settings,
    required this.conditions,
    required this.playingNations,
    required this.transfers,
    required this.money,
  });
}
