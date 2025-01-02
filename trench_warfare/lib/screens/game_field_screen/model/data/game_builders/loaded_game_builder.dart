part of game_builders;

class LoadedGameBuilder implements GameBuilder {
  late final _dao = Database.saveLoadGameDao;

  static const _humanIndex = 0;

  final GameSlot _slot;

  LoadedGameBuilder({required GameSlot slot}) : _slot = slot;

  @override
  Future<GameBuildResult> build() async {
    final slotDb = _dao.readSlot(_slot.index)!;

    final metadataRecord = await MapMetadataDecoder.decodeFromFile(slotDb.mapFileName);
    final metadata = MapMetadata(metadataRecord!);

    final dbUnits = _dao.readAllUnits(slotDb.dbId);

    final gameField = _getGameField(slotDb, dbUnits);

    final dbNations =
        _dao.readAllNations(slotDb.dbId).sorted((k1, k2) => k1.playingOrder.compareTo(k2.playingOrder));
    final conditions = GameOverConditionsCalculator(
      gameField: gameField,
      metadata: metadata,
      defeated: dbNations
          .where((n) => n.defeated)
          .map((n) => Nation.createFromIndex(n.nation))
          .toList(growable: false),
    );

    final dbTransfers = _dao.readAllTroopTransfers(slotDb.dbId);
    final transfers = _getTransfers(dbTransfers, dbNations, dbUnits, gameField);

    final playingNations = _getPlayingNations(metadata, dbNations);

    return GameBuildResult(
      humanIndex: _humanIndex,
      isGameLoaded: true,
      mapFileName: slotDb.mapFileName,
      nationsDayNumber: dbNations.map((n) => n.day).toList(growable: false),
      metadata: metadata,
      gameField: gameField,
      settings: _getSettings(slotDb),
      conditions: conditions,
      playingNations: playingNations,
      transfers: transfers,
      money: _getMoney(dbNations, gameField),
      humanUnitsSpeed: SettingsStorageFacade.humanUnitsSpeed,
      aiUnitsSpeed: SettingsStorageFacade.aiUnitsSpeed,
    );
  }

  GameFieldSettingsStorage _getSettings(SaveSlotDbEntity slotDb) {
    final settings = _dao.readAllSettings(slotDb.dbId).firstOrNull;

    final storage = GameFieldSettingsStorage();

    if (settings != null) {
      storage.zoom = settings.zoom;

      if (settings.cameraPositionX != null && settings.cameraPositionY != null) {
        storage.cameraPosition = Vector2(settings.cameraPositionX!, settings.cameraPositionY!);
      }
    }

    return storage;
  }

  GameField _getGameField(SaveSlotDbEntity slotDb, List<SaveUnitDbEntity> dbUnits) {
    final dbCells = _dao.readAllCells(slotDb.dbId);

    final cells = <GameFieldCell>[];

    for (final dbCell in dbCells) {
      final cell = _mapCellFromDb(dbCell);

      final cellUnits = dbUnits
          .where((u) => u.cellDbId == dbCell.dbId)
          .sorted((i1, i2) => i1.orderInCell.compareTo(i2.orderInCell));

      if (cellUnits.isNotEmpty) {
        cell.addUnits(cellUnits.map((u) => _mapUnitFromDb(u, dbUnits)));
      }

      cells.add(cell);
    }

    return GameField(cells, rows: slotDb.rows, cols: slotDb.cols);
  }

  GameFieldCell _mapCellFromDb(SaveGameFieldCellDbEntity dbCell) {
    final cell = GameFieldCell(
      terrain: CellTerrain.createFromIndex(dbCell.terrain),
      hasRiver: dbCell.hasRiver,
      hasRoad: dbCell.hasRoad,
      center: Vector2(dbCell.centerX, dbCell.centerY),
      row: dbCell.row,
      col: dbCell.col,
    );

    dbCell.terrainModifier?.let(
        (tm) => cell.setTerrainModifier(TerrainModifier(type: TerrainModifierType.createFromIndex(tm))));

    dbCell.nation?.let((n) => cell.setNation(Nation.createFromIndex(n)));

    if (dbCell.pathItemType != null) {
      cell.setPathItem(PathItem(
        type: PathItemType.createFromIndex(dbCell.pathItemType!),
        isActive: dbCell.pathItemIsActive!,
        movementPointsLeft: dbCell.pathItemMovementPointsLeft!,
      ));
    }

    if (dbCell.productionCenterType != null) {
      cell.setProductionCenter(ProductionCenter(
        type: ProductionCenterType.createFromIndex(dbCell.productionCenterType!),
        level: ProductionCenterLevel.createFromIndex(dbCell.productionCenterLevel!),
        name: dbCell.productionCenterName,
      ));
    }

    return cell;
  }

  Unit _mapUnitFromDb(SaveUnitDbEntity dbUnit, List<SaveUnitDbEntity> allUnits) {
    final unitType = UnitType.createFromIndex(dbUnit.type);

    if (unitType == UnitType.carrier) {
      final carrier = Carrier.restoreAfterSaving(
        id: dbUnit.unitId,
        boost1: dbUnit.boost1?.let((b) => UnitBoost.createFromIndex(b)),
        boost2: dbUnit.boost2?.let((b) => UnitBoost.createFromIndex(b)),
        boost3: dbUnit.boost3?.let((b) => UnitBoost.createFromIndex(b)),
        fatigue: dbUnit.fatigue,
        health: dbUnit.health,
        movementPoints: dbUnit.movementPoints,
        defence: dbUnit.defence,
        tookPartInBattles: dbUnit.tookPartInBattles,
        type: unitType,
        state: UnitState.createFromIndex(dbUnit.state),
      );

      final carrierUnits = allUnits
          .where((u) => u.carrierDbId == dbUnit.dbId)
          .sorted((i1, i2) => i1.orderInCell.compareTo(i2.orderInCell));

      if (carrierUnits.isNotEmpty) {
        carrier.addUnits(carrierUnits.map((u) => _mapUnitFromDb(u, [])));
      }

      return carrier;
    } else {
      return Unit.restoreAfterSaving(
        id: dbUnit.unitId,
        boost1: dbUnit.boost1?.let((b) => UnitBoost.createFromIndex(b)),
        boost2: dbUnit.boost2?.let((b) => UnitBoost.createFromIndex(b)),
        boost3: dbUnit.boost3?.let((b) => UnitBoost.createFromIndex(b)),
        tookPartInBattles: dbUnit.tookPartInBattles,
        fatigue: dbUnit.fatigue,
        health: dbUnit.health,
        movementPoints: dbUnit.movementPoints,
        defence: dbUnit.defence,
        type: unitType,
        state: UnitState.createFromIndex(dbUnit.state),
      );
    }
  }

  List<NationRecord> _getPlayingNations(MapMetadata metadata, List<SaveNationDbEntity> dbNations) {
    final result = <NationRecord>[];

    for (final dbNation in dbNations) {
      final nationCode = Nation.createFromIndex(dbNation.nation);

      result.add(metadata.nations.firstWhere((n) => n.code == nationCode));
    }

    return result;
  }

  Map<Nation, Iterable<TroopTransferReadForSaving>> _getTransfers(
    List<SaveTroopTransferDbEntity> dbTransfers,
    List<SaveNationDbEntity> dbNations,
    List<SaveUnitDbEntity> dbUnits,
    GameFieldRead gameField,
  ) {
    final result = <Nation, Iterable<TroopTransferReadForSaving>>{};

    for (final dbNation in dbNations) {
      final dbNationTransfers =
          dbTransfers.where((t) => t.nationDbId == dbNation.dbId).toList(growable: false);
      if (dbNationTransfers.isEmpty) {
        continue;
      }

      final nation = Nation.createFromIndex(dbNation.nation);

      final transfers = dbNationTransfers.map((t) {
        LandingPoint? gatheringPoint;
        if (t.gatheringPointCarrierCellId != null && t.gatheringPointUnitsCellId != null) {
          gatheringPoint = LandingPoint(
            carrierCell: gameField.findCellById(t.gatheringPointCarrierCellId!)!,
            unitsCell: gameField.findCellById(t.gatheringPointUnitsCellId!)!,
          );
        }

        LandingPoint? landingPoint;
        if (t.landingPointCarrierCellId != null && t.landingPointUnitsCellId != null) {
          landingPoint = LandingPoint(
            carrierCell: gameField.findCellById(t.landingPointCarrierCellId!)!,
            unitsCell: gameField.findCellById(t.landingPointUnitsCellId!)!,
          );
        }

        final transportingUnits = dbUnits
            .where((u) => u.troopTransferDbId == t.dbId)
            .map((u) => gameField.findUnitById(u.unitId, nation)!)
            .toList(growable: false);

        return TroopTransferReadForSavingImpl(
          gatheringPoint: gatheringPoint,
          id: t.troopTransferId,
          landingPoint: landingPoint,
          selectedCarrierId: t.selectedCarrierId,
          stateAlias: t.stateAlias,
          targetCell: gameField.findCellById(t.targetCellId)!,
          transportingUnits: transportingUnits,
        );
      }).toList(growable: false);

      result[Nation.createFromIndex(dbNation.nation)] = transfers;
    }

    return result;
  }

  Map<Nation, MoneyStorage> _getMoney(List<SaveNationDbEntity> dbNations, GameFieldRead gameField) {
    final entries = dbNations.map((n) => MapEntry(
          Nation.createFromIndex(n.nation),
          MoneyStorage.fromSaving(
            gameField,
            Nation.createFromIndex(n.nation),
            totalSumCurrency: n.totalSumCurrency,
            totalSumIndustryPoints: n.totalSumIndustryPoints,
            totalIncomeCurrency: n.totalIncomeCurrency,
            totalIncomeIndustryPoints: n.totalIncomeIndustryPoints,
            totalExpensesCurrency: n.totalExpensesCurrency,
            totalExpensesIndustryPoints: n.totalExpensesIndustryPoints,
          ),
        ));

    return Map.fromEntries(entries);
  }
}
