part of peaceful_player_ai;

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

      final pcEstimationResult = _estimateProductionCentersInGeneral(influences);
      final minesEstimationResult = _estimateMineFieldsInGeneral(influences);
      final unitsEstimationResult = _estimateUnitsInGeneral(influences);

      final averageWeights = [
        pcEstimationResult.isEmpty
            ? 0.0
            : pcEstimationResult.map((e) => e.weight).average().let((v) => v == 0 ? 0.0 : log10(v))!,
        minesEstimationResult.isEmpty
            ? 0.0
            : minesEstimationResult.map((e) => e.weight).average().let((v) => v == 0 ? 0.0 : log10(v))!,
        unitsEstimationResult.isEmpty
            ? 0.0
            : unitsEstimationResult.map((e) => e.weight).average().let((v) => v == 0 ? 0.0 : log10(v))!,
      ];

      final generalActionIndex = RandomGen.randomWeight(averageWeights);

      // We can't make a general decision. The presumable reason - we're short of money, or build
      // everything we can
      if (generalActionIndex == null) {
        break;
      }

      switch (generalActionIndex) {
        case 0:
          _processProductionCenter(pcEstimationResult);
        case 1:
          _processMines(minesEstimationResult, influences);
        case 2:
          _processUnits(unitsEstimationResult, influences);
      }
    }

    await Future.delayed(const Duration(seconds: 1));
    player.onEndOfTurnButtonClick();
  }

  Iterable<EstimationResult<ProductionCenterEstimationData>> _estimateProductionCentersInGeneral(
    InfluenceMapRepresentationRead influenceMap,
  ) {
    final List<EstimationResult<ProductionCenterEstimationData>> result = [];

    final types = [ProductionCenterType.navalBase, ProductionCenterType.city, ProductionCenterType.factory];

    for (final type in types) {
      final estimator = ProductionCenterEstimator(
        gameField: _gameField,
        myNation: _myNation,
        nationMoney: _nationMoney.actual,
        type: type,
        influenceMap: influenceMap,
        metadata: _metadata,
      );

      result.addAll(estimator.estimate());
    }

    return result;
  }

  Iterable<EstimationResult<MineFieldsEstimationData>> _estimateMineFieldsInGeneral(
    InfluenceMapRepresentationRead influenceMap,
  ) {
    final List<EstimationResult<MineFieldsEstimationData>> result = [];

    final types = [TerrainModifierType.landMine, TerrainModifierType.seaMine];

    for (final type in types) {
      final estimator = MineFieldsEstimator(
          gameField: _gameField,
          myNation: _myNation,
          type: type,
          nationMoney: _nationMoney.actual,
          influenceMap: influenceMap,
          metadata: _metadata);

      result.addAll(estimator.estimate());
    }

    return result;
  }

  Iterable<EstimationResult<UnitsEstimationData>> _estimateUnitsInGeneral(
    InfluenceMapRepresentationRead influenceMap,
  ) {
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
          nationMoney: _nationMoney.actual,
          influenceMap: influenceMap,
          metadata: _metadata);

      result.addAll(estimator.estimate());
    }

    return result;
  }

  void _processProductionCenter(Iterable<EstimationResult<ProductionCenterEstimationData>> source) {
    final allWeights = source.map((e) => 1.0).toList(growable: false);

    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return;
    }

    // User action simulation
    _simulateCardSelection(
      card: GameFieldControlsProductionCentersCardBrief(type: source.elementAt(caseIndex).data.type),
      cell: source.elementAt(caseIndex).data.cell,
    );
  }

  void _processMines(
    Iterable<EstimationResult<MineFieldsEstimationData>> source,
    InfluenceMapRepresentationRead influenceMap,
  ) {
    final allWeights = source.map((e) => e.data.dangerousFactor).toList(growable: false);

    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return;
    }

    // User action simulation
    _simulateCardSelection(
      card: GameFieldControlsTerrainModifiersCardBrief(type: source.elementAt(caseIndex).data.type),
      cell: source.elementAt(caseIndex).data.cell,
    );
  }

  void _processUnits(
    Iterable<EstimationResult<UnitsEstimationData>> source,
    InfluenceMapRepresentationRead influenceMap,
  ) {
    final allWeights = source.map((e) => e.data.dangerousFactor).toList(growable: false);

    final caseIndex = RandomGen.randomWeight(allWeights);

    if (caseIndex == null) {
      return;
    }

    // User action simulation
    _simulateCardSelection(
      card: GameFieldControlsUnitCardBrief(type: source.elementAt(caseIndex).data.type),
      cell: source.elementAt(caseIndex).data.cell,
    );
  }

  void _simulateCardSelection({required GameFieldControlsCard card, required GameFieldCellRead cell}) {
    player.onCardsButtonClick();
    player.onCardSelected(card);
    player.onClick(cell.center);
    player.onCardsPlacingCancelled();
  }
}
