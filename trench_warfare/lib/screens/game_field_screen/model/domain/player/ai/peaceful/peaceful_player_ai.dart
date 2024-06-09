part of player_ai;

class PeacefulPlayerAi extends PlayerAi {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyUnit _nationMoney;

  final MapMetadataRead _metadata;

  PeacefulPlayerAi(
    this._gameField,
    super.player,
    this._myNation,
    this._nationMoney,
    this._metadata,
  );

  @override
  void start() async {
    while(true) {
      final influences = InfluenceMapRepresentation()
        ..calculate(_gameField);

      final pcGeneralEstimationResult = _estimateProductionCentersInGeneral(influences);
      final minesGeneralEstimationResult = _estimateMineFieldsInGeneral(influences);
      final unitsGeneralEstimationResult = _estimateUnitsInGeneral(influences);

      final generalActionIndex = RandomGen.randomWeight([
        pcGeneralEstimationResult.entries.map((e) => e.value.weight).average(),
        minesGeneralEstimationResult.entries.map((e) => e.value.weight).average(),
        unitsGeneralEstimationResult.entries.map((e) => e.value.weight).average(),
      ]);

      // We can't make a general decision. The presumable reason - we're short of money, or build
      // everything we can
      if (generalActionIndex == null) {
        break;
      }

      switch (generalActionIndex) {
        case 0:
          _processProductionCenter(pcGeneralEstimationResult);
        case 1:
          _processMines(minesGeneralEstimationResult, influences);
        case 2:
          _processUnits(unitsGeneralEstimationResult, influences);
      }
    }

    await Future.delayed(const Duration(seconds: 1));
    _player.onEndOfTurnButtonClick();
  }

  Map<ProductionCenterType, ProductionCenterInGeneralEstimationResult> _estimateProductionCentersInGeneral(
    InfluenceMapRepresentationRead influenceMap,
  ) {
    final Map<ProductionCenterType, ProductionCenterInGeneralEstimationResult> result = {};

    final types = [ProductionCenterType.navalBase, ProductionCenterType.city, ProductionCenterType.factory];

    for (final type in types) {
      final estimator = ProductionCenterInGeneralEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney,
        type: type,
        influenceMap: influenceMap,
        metadata: _metadata,
      );

      result[type] = estimator.estimate();
    }

    return result;
  }

  Map<TerrainModifierType, MineFieldsInGeneralEstimationResult> _estimateMineFieldsInGeneral(
    InfluenceMapRepresentationRead influenceMap,
  ) {
    final Map<TerrainModifierType, MineFieldsInGeneralEstimationResult> result = {};

    final types = [TerrainModifierType.landMine, TerrainModifierType.seaMine];

    for (final type in types) {
      final estimator = MineFieldsInGeneralEstimator(
          gameField: _gameField,
          myNation: _myNation,
          type: type,
          nationMoney: _nationMoney,
          influenceMap: influenceMap,
          metadata: _metadata);

      result[type] = estimator.estimate();
    }

    return result;
  }

  Map<UnitType, UnitsInGeneralEstimationResult> _estimateUnitsInGeneral(
    InfluenceMapRepresentationRead influenceMap,
  ) {
    final Map<UnitType, UnitsInGeneralEstimationResult> result = {};

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
      final estimator = UnitsInGeneralEstimator(
          gameField: _gameField,
          myNation: _myNation,
          type: type,
          nationMoney: _nationMoney,
          influenceMap: influenceMap,
          metadata: _metadata);

      result[type] = estimator.estimate();
    }

    return result;
  }

  void _processProductionCenter(Map<ProductionCenterType, ProductionCenterInGeneralEstimationResult> source) {
    // Selecting a type of production center
    final allWeights = source.entries.map((e) => e.value.weight).toList(growable: false);
    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return;
    }

    final selectedType = source.entries.elementAt(caseIndex).key;

    // Selecting a specific cell
    final cellsToBuild = source.entries.elementAt(caseIndex).value.cellsPossibleToBuild;
    final cellToBuildIndex =
        RandomGen.randomWeight(cellsToBuild.map((c) => EqualsEstimator().estimate().weight));

    if (cellToBuildIndex == null) {
      return;
    }

    // User action simulation
    _simulateCardSelection(
      card: GameFieldControlsProductionCentersCardBrief(type: selectedType),
      cell: cellsToBuild.elementAt(cellToBuildIndex),
    );
  }

  void _processMines(
    Map<TerrainModifierType, MineFieldsInGeneralEstimationResult> source,
    InfluenceMapRepresentationRead influenceMap,
  ) {
    // Selecting a type of mine field
    final allWeights = source.entries.map((e) => e.value.weight).toList(growable: false);
    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return;
    }

    final selectedType = source.entries.elementAt(caseIndex).key;

    // Selecting a specific cell
    final cellsToBuild = source.entries.elementAt(caseIndex).value.cellsPossibleToPlace;
    final cellToBuildIndex = RandomGen.randomWeight(cellsToBuild.map((c) =>
        DangerousEstimator(cell: c, influenceMap: influenceMap, metadata: _metadata).estimate().weight));

    if (cellToBuildIndex == null) {
      return;
    }

    // User action simulation
    _simulateCardSelection(
      card: GameFieldControlsTerrainModifiersCardBrief(type: selectedType),
      cell: cellsToBuild.elementAt(cellToBuildIndex),
    );
  }

  void _processUnits(
    Map<UnitType, UnitsInGeneralEstimationResult> source,
    InfluenceMapRepresentationRead influenceMap,
  ) {
    // Selecting a type of mine field
    final allWeights = source.entries.map((e) => e.value.weight).toList(growable: false);
    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return;
    }

    final selectedType = source.entries.elementAt(caseIndex).key;

    // Selecting a specific cell
    final cellsToBuild = source.entries.elementAt(caseIndex).value.cellsPossibleToHire;
    final cellToBuildIndex = RandomGen.randomWeight(cellsToBuild.map((c) =>
        DangerousEstimator(cell: c, influenceMap: influenceMap, metadata: _metadata).estimate().weight));

    if (cellToBuildIndex == null) {
      return;
    }

    // User action simulation
    _simulateCardSelection(
      card: GameFieldControlsUnitCardBrief(type: selectedType),
      cell: cellsToBuild.elementAt(cellToBuildIndex),
    );
  }

  void _simulateCardSelection({required GameFieldControlsCard card, required GameFieldCellRead cell}) {
    _player.onCardsButtonClick();
    _player.onCardSelected(card);
    _player.onClick(cell.center);
  }
}
