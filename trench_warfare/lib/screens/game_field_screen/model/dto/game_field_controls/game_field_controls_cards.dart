part of game_field_controls;

abstract interface class BuildPossibility {
  final bool canBuildByCurrency = false;
  final bool canBuildByIndustryPoint = false;
  final BuildRestriction? buildDisplayRestriction = null;
  final BuildRestriction? buildError = null;
}
abstract class GameFieldControlsCard<T> implements BuildPossibility {
  T get type;
}

class GameFieldControlsUnitCard extends GameFieldControlsCard<UnitType> {
  final MoneyUnit cost;

  @override
  final UnitType type;

  final int maxHealth;

  final int attack;
  final int defence;

  final Range<int> damage;

  final double movementPoints;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final BuildRestriction? buildDisplayRestriction;

  @override
  BuildRestriction? buildError;

  GameFieldControlsUnitCard({
    required this.cost,
    required this.type,
    required this.maxHealth,
    required this.attack,
    required this.defence,
    required this.damage,
    required this.movementPoints,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.buildDisplayRestriction,
    required this.buildError,
  });

  @override
  String toString() => 'CARD: {units. type: $type}';
}

class GameFieldControlsUnitCardBrief extends GameFieldControlsCard<UnitType> {
  @override
  final UnitType type;

  GameFieldControlsUnitCardBrief({
    required this.type,
  });

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  String toString() => 'CARD: {units brief. type: $type}';
}

class GameFieldControlsProductionCentersCard extends GameFieldControlsCard<ProductionCenterType> {
  final MoneyUnit cost;

  @override
  final ProductionCenterType type;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final BuildRestriction? buildDisplayRestriction;

  @override
  BuildRestriction? buildError;

  GameFieldControlsProductionCentersCard({
    required this.cost,
    required this.type,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.buildDisplayRestriction,
    required this.buildError,
  });

  @override
  String toString() => 'CARD: {production center. type: $type}';
}

class GameFieldControlsProductionCentersCardBrief extends GameFieldControlsCard<ProductionCenterType> {
  @override
  final ProductionCenterType type;

  GameFieldControlsProductionCentersCardBrief({
    required this.type,
  });

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  String toString() => 'CARD: {production center brief. type: $type}';
}

class GameFieldControlsTerrainModifiersCard extends GameFieldControlsCard<TerrainModifierType> {
  final MoneyUnit cost;

  @override
  final TerrainModifierType type;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final BuildRestriction? buildDisplayRestriction;

  @override
  BuildRestriction? buildError;

  GameFieldControlsTerrainModifiersCard({
    required this.cost,
    required this.type,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.buildDisplayRestriction,
    required this.buildError,
  });

  @override
  String toString() => 'CARD: {terrain modifier. type: $type}';
}

class GameFieldControlsTerrainModifiersCardBrief extends GameFieldControlsCard<TerrainModifierType> {
  @override
  final TerrainModifierType type;

  GameFieldControlsTerrainModifiersCardBrief({
    required this.type,
  });

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  String toString() => 'CARD: {terrain modifier brief. type: $type}';
}

class GameFieldControlsUnitBoostersCard extends GameFieldControlsCard<UnitBoost> {
  final MoneyUnit cost;

  @override
  final UnitBoost type;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final BuildRestriction? buildDisplayRestriction;

  @override
  BuildRestriction? buildError;

  GameFieldControlsUnitBoostersCard({
    required this.cost,
    required this.type,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.buildDisplayRestriction,
    required this.buildError,
  });

  @override
  String toString() => 'CARD: {unit booster. type: $type}';
}

class GameFieldControlsUnitBoostersCardBrief extends GameFieldControlsCard<UnitBoost> {
  @override
  final UnitBoost type;

  GameFieldControlsUnitBoostersCardBrief({
    required this.type,
  });

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  String toString() => 'CARD: {unit booster brief. type: $type}';
}

class GameFieldControlsSpecialStrikesCard extends GameFieldControlsCard<SpecialStrikeType> {
  final MoneyUnit cost;

  @override
  final SpecialStrikeType type;

  @override
  final bool canBuildByCurrency;

  @override
  final bool canBuildByIndustryPoint;

  @override
  final BuildRestriction? buildDisplayRestriction;

  @override
  BuildRestriction? buildError;

  GameFieldControlsSpecialStrikesCard({
    required this.cost,
    required this.type,
    required this.canBuildByCurrency,
    required this.canBuildByIndustryPoint,
    required this.buildDisplayRestriction,
    required this.buildError,
  });

  @override
  String toString() => 'CARD: {special strike. type: $type}';
}

class GameFieldControlsSpecialStrikesCardBrief extends GameFieldControlsCard<SpecialStrikeType> {
  @override
  final SpecialStrikeType type;

  GameFieldControlsSpecialStrikesCardBrief({
    required this.type,
  });

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  String toString() => 'CARD: {special strike brief. type: $type}';
}
