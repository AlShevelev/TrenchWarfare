import 'package:trench_warfare/core_entities/enums/nation.dart';

sealed class VictoryType {
  final Nation nation;

  VictoryType({required this.nation});
}

/// A global victory of some player - end of a game
class GlobalVictory extends VictoryType {
  GlobalVictory({required super.nation});
}

/// Some nation has been defeated but a game is not over
class Defeat extends VictoryType {
  Defeat({required super.nation});
}

