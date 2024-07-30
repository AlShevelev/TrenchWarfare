import 'package:trench_warfare/core_entities/enums/nation.dart';

sealed class GameOverConditions {
  final Nation nation;

  GameOverConditions({required this.nation});
}

/// A global victory of some player - end of a game
class GlobalVictory extends GameOverConditions {
  GlobalVictory({required super.nation});
}

/// Some nation has been defeated but a game is not over
class Defeat extends GameOverConditions {
  Defeat({required super.nation});
}

