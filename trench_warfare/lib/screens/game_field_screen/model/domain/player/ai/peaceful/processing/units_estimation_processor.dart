/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of peaceful_player_ai;

class UnitsEstimationProcessor extends EstimationProcessorBase<UnitsEstimationData> {
  UnitsEstimationProcessor({
    required super.player,
    required super.gameField,
    required super.myNation,
    required super.nationMoney,
    required super.metadata,
    required super.influenceMap,
  });

  @override
  Iterable<EstimationResult<UnitsEstimationData>> _makeEstimations() {
    final List<EstimationResult<UnitsEstimationData>> result = [];

    final types = [
      UnitType.armoredCar,
      UnitType.artillery,
      UnitType.infantry,
      UnitType.cavalry,
      UnitType.machineGunnersCart,
      UnitType.machineGuns,
      UnitType.tank,
      UnitType.destroyer,
      UnitType.cruiser,
      UnitType.battleship
    ];

    for (final type in types) {
      final estimator = UnitsEstimator(
          gameField: _gameField,
          myNation: _myNation,
          type: type,
          nationMoney: _nationMoney,
          influenceMap: _influenceMap,
          metadata: _metadata);

      result.addAll(estimator.estimate());
    }

    return result;
  }

  @override
  Future<void> process() async {
    final allWeights = _estimationResult.map((e) => e.data.dangerousFactor).toList(growable: false);

    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return;
    }

    // User action simulation
    await _simulateCardSelection(
      card: GameFieldControlsUnitCardBrief(type: _estimationResult.elementAt(caseIndex).data.type),
      cell: _estimationResult.elementAt(caseIndex).data.cell,
    );
  }
}
