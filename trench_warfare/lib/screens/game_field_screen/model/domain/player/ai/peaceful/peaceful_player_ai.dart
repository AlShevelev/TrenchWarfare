part of player_ai;

class PeacefulPlayerAi extends PlayerAi {
  final GameFieldRead _gameField;

  final Nation _myNation;

  final MoneyStorageRead _nationMoney;

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
    while (true) {
      final influences = await compute<GameFieldRead, InfluenceMapRepresentationRead>(
          (data) => InfluenceMapRepresentation()..calculate(data), _gameField);

      final pcGeneralEstimationResult = _estimateProductionCentersInGeneral(influences);
      final minesGeneralEstimationResult = _estimateMineFieldsInGeneral(influences);
      final unitsGeneralEstimationResult = _estimateUnitsInGeneral(influences);

      final averageWeights = [
        pcGeneralEstimationResult.map((e) => e.result.weight).average(),
        minesGeneralEstimationResult.map((e) => e.result.weight).average(),
        unitsGeneralEstimationResult.map((e) => e.result.weight).average(),
      ];

      final generalActionIndex = RandomGen.randomWeight(averageWeights);

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

  List<ProductionCenterEstimationRecord> _estimateProductionCentersInGeneral(
    InfluenceMapRepresentationRead influenceMap,
  ) {
    final List<ProductionCenterEstimationRecord> result = [];

    final types = [ProductionCenterType.navalBase, ProductionCenterType.city, ProductionCenterType.factory];

    for (final type in types) {
      final estimator = ProductionCenterInGeneralEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        type: type,
        influenceMap: influenceMap,
        metadata: _metadata,
      );

      result.add(ProductionCenterEstimationRecord(type: type, result: estimator.estimate()));
    }

    return result;
  }

  List<TerrainModifierEstimationRecord> _estimateMineFieldsInGeneral(
    InfluenceMapRepresentationRead influenceMap,
  ) {
    final List<TerrainModifierEstimationRecord> result = [];

    final types = [TerrainModifierType.landMine, TerrainModifierType.seaMine];

    for (final type in types) {
      final estimator = MineFieldsInGeneralEstimator(
          gameField: _gameField,
          myNation: _myNation,
          type: type,
          nationMoney: _nationMoney.actual,
          influenceMap: influenceMap,
          metadata: _metadata);

      result.add(TerrainModifierEstimationRecord(type: type, result: estimator.estimate()));
    }

    return result;
  }

  List<UnitsEstimationRecord> _estimateUnitsInGeneral(
    InfluenceMapRepresentationRead influenceMap,
  ) {
    final List<UnitsEstimationRecord> result = [];

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
          nationMoney: _nationMoney.actual,
          influenceMap: influenceMap,
          metadata: _metadata);

      result.add(UnitsEstimationRecord(type: type, result: estimator.estimate()));
    }

    return result;
  }

  void _processProductionCenter(List<ProductionCenterEstimationRecord> source) {
    // Selecting a type of production center
    final allWeights = source.map((e) => e.result.weight).toList(growable: false);
    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return;
    }

    final selectedType = source.elementAt(caseIndex).type;

    // Selecting a specific cell
    final cellsToBuild = source.elementAt(caseIndex).result.cellsPossibleToBuild;
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
    List<TerrainModifierEstimationRecord> source,
    InfluenceMapRepresentationRead influenceMap,
  ) {
    // Selecting a type of mine field
    final allWeights = source.map((e) => e.result.weight).toList(growable: false);
    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return;
    }

    final selectedType = source.elementAt(caseIndex).type;

    // Selecting a specific cell
    final cellsToBuild = source.elementAt(caseIndex).result.cellsPossibleToPlace;
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
    List<UnitsEstimationRecord> source,
    InfluenceMapRepresentationRead influenceMap,
  ) {
    // Selecting a type of mine field
    final allWeights = source.map((e) => e.result.weight).toList(growable: false);
    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return;
    }

    final selectedType = source.elementAt(caseIndex).type;

    // Selecting a specific cell
    final cellsToBuild = source.elementAt(caseIndex).result.cellsPossibleToHire;
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
    _player.onCardsPlacingCancelled();
  }
}
