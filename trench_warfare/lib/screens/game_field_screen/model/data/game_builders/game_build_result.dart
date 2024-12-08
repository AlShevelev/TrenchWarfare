part of game_builders;

class GameBuildResult {
  final int humanIndex;

  final String mapFileName;

  final int dayNumber;

  final MapMetadata metadata;

  final GameField gameField;

  final GameFieldSettingsStorage settings;

  final GameOverConditionsCalculator conditions;

  final List<NationRecord> playingNations;

  final Map<Nation, Iterable<TroopTransferReadForSaving>> transfers;

  final Map<Nation, MoneyStorage> money;

  GameBuildResult({
    required this.humanIndex,
    required this.mapFileName,
    required this.dayNumber,
    required this.metadata,
    required this.gameField,
    required this.settings,
    required this.conditions,
    required this.playingNations,
    required this.transfers,
    required this.money,
  });
}
