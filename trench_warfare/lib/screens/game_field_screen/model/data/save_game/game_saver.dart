part of save_game;

abstract interface class GameSaverBuilder {
  void save();

  void addGameField(GameFieldRead gameField);

  void addSettings(GameFieldSettingsStorageRead settingsStorage);

  void addDefeated(Iterable<Nation> defeated);

  void addPlayingNations(Iterable<Nation> playingNations);

  void addTroopTransfers(Map<Nation, Iterable<TroopTransferReadForSaving>> troopTransfers);
}

class GameSaver implements GameSaverBuilder {
  late final _dao = Database.saveLoadGameDao;

  late final GameFieldRead _gameField;

  final int _slotNumber;

  final String _mapId;

  final bool _isAutosave;

  final int _day;

  late final GameFieldSettingsStorageRead _settingsStorage;

  late final Iterable<Nation> _defeated;

  late final Iterable<Nation> _playingNations;

  late final Map<Nation, Iterable<TroopTransferReadForSaving>> _troopTransfers;

  final int _humanPlayerIndex;

  GameSaver._(
    GameSlot slot,
    String mapId,
    bool isAutosave,
    int day,
    int humanPlayerIndex,
  )   : _mapId = mapId,
        _isAutosave = isAutosave,
        _day = day,
        _humanPlayerIndex = humanPlayerIndex,
        _slotNumber = slot.index;

  static GameSaverBuilder start({
    required GameSlot slot,
    required String mapId,
    required bool isAutosave,
    required int day,
    required int humanPlayerIndex,
  }) {
    return GameSaver._(slot, mapId, isAutosave, day, humanPlayerIndex);
  }

  @override
  void save() {
    // The old slot must be removed first
    _dao.deleteSlot(_slotNumber);

    // Creating a new slot
    final slotDbRecord = SaveSlotDbEntity(
      slotNumber: _slotNumber,
      mapId: _mapId,
      isAutosave: _isAutosave,
      day: _day,
      saveDateTime: DateTime.now(),
    );
    _dao.createSlot(slotDbRecord);

    // Saving the settings
    final dbSettings = _mapSettingsToDbEntity(_settingsStorage, slotDbId: slotDbRecord.dbId);
    _dao.createSettings(dbSettings);

    // Saving the playing nations
    // A link between a unit Id (String) and db's id of a transfer
    final Map<String, int> unitsInTransfers = {};

    for (var i = 0; i < _playingNations.length; i++) {
      final nation = _playingNations.elementAt(i);
      final dbNation = SaveNationDbEntity(
        slotDbId: slotDbRecord.dbId,
        isHuman: i == _humanPlayerIndex,
        playingOrder: i,
        nation: nation.index,
        defeated: _defeated.contains(nation),
      );
      _dao.createNation(dbNation);

      // Saving the nations' transfer
      final transfers = _troopTransfers[nation];
      if (transfers != null) {
        for (final transfer in transfers) {
          final transferRecord = _mapTransferToDbEntity(
            transfer,
            slotDbId: slotDbRecord.dbId,
            nationDbId: dbNation.dbId,
          );

          _dao.createTroopTransfer(transferRecord);

          for (final unit in transfer.transportingUnits) {
            unitsInTransfers[unit.id] = transferRecord.dbId;
          }
        }
      }
    }

    // Saving the game field
    for (final cell in _gameField.cells) {
      final dbCell = _mapCellToDbEntity(slotDbId: slotDbRecord.dbId, cell);

      _dao.createCell(dbCell);

      // Saving units
      for (var i = 0; i < cell.units.length; i++) {
        final unit = cell.units.elementAt(i);

        final dbUnit = _maUnitToDbEntity(
          unit,
          slotDbId: slotDbRecord.dbId,
          cellDbId: dbCell.dbId,
          carrierDbId: null,
          troopTransferDbId: unitsInTransfers[unit.id],
          index: i,
        );

        _dao.createUnit(dbUnit);

        // Saving carrier's units
        if (unit.type == UnitType.carrier) {
          final carrier = unit as Carrier;

          for (var j = 0; j < carrier.units.length; j++) {
            final carrierInsideUnit = carrier.units.elementAt(j);

            final dbCarrierInsideUnit = _maUnitToDbEntity(
              carrierInsideUnit,
              slotDbId: slotDbRecord.dbId,
              cellDbId: null,
              carrierDbId: dbUnit.dbId,
              troopTransferDbId: unitsInTransfers[unit.id],
              index: j,
            );

            _dao.createUnit(dbCarrierInsideUnit);
          }
        }
      }
    }
  }

  @override
  void addGameField(GameFieldRead gameField) => _gameField = gameField;

  @override
  void addSettings(GameFieldSettingsStorageRead settingsStorage) => _settingsStorage = settingsStorage;

  @override
  void addDefeated(Iterable<Nation> defeated) => _defeated = defeated;

  @override
  void addPlayingNations(Iterable<Nation> playingNations) => _playingNations = playingNations;

  @override
  void addTroopTransfers(Map<Nation, Iterable<TroopTransferReadForSaving>> troopTransfers) =>
      _troopTransfers = troopTransfers;

  SaveGameFieldCellDbEntity _mapCellToDbEntity(
    GameFieldCell cell, {
    required int slotDbId,
  }) =>
      SaveGameFieldCellDbEntity(
        slotDbId: slotDbId,
        row: cell.row,
        col: cell.col,
        cellId: cell.id,
        centerX: cell.center.x,
        centerY: cell.center.y,
        terrain: cell.terrain.index,
        hasRiver: cell.hasRiver,
        hasRoad: cell.hasRoad,
        nation: cell.nation?.index,
        productionCenterType: cell.productionCenter?.type.index,
        productionCenterLevel: cell.productionCenter?.level.index,
        terrainModifier: cell.terrainModifier?.type.index,
        pathItemType: cell.pathItem?.type.index,
        pathItemIsActive: cell.pathItem?.isActive,
        pathItemMovementPointsLeft: cell.pathItem?.movementPointsLeft,
      );

  SaveUnitDbEntity _maUnitToDbEntity(
    Unit unit, {
    required int slotDbId,
    required int? cellDbId,
    required int? carrierDbId,
    required int? troopTransferDbId,
    required int index,
  }) =>
      SaveUnitDbEntity(
        slotDbId: slotDbId,
        cellDbId: cellDbId,
        carrierDbId: carrierDbId,
        troopTransferDbId: troopTransferDbId,
        unitId: unit.id,
        orderInCell: index,
        boost1: unit.boost1?.index,
        boost2: unit.boost2?.index,
        boost3: unit.boost3?.index,
        tookPartInBattles: unit.tookPartInBattles,
        fatigue: unit.fatigue,
        health: unit.health,
        movementPoints: unit.movementPoints,
        defence: unit.defence,
        type: unit.type.index,
        state: unit.state.index,
      );

  SaveTroopTransferDbEntity _mapTransferToDbEntity(
    TroopTransferReadForSaving transfer, {
    required int slotDbId,
    required int nationDbId,
  }) =>
      SaveTroopTransferDbEntity(
        slotDbId: slotDbId,
        nationDbId: nationDbId,
        targetCellId: transfer.targetCell.id,
        troopTransferId: transfer.id,
        stateAlias: transfer.stateAlias,
        selectedCarrierId: transfer.selectedCarrierId,
        landingPointCarrierCellId: transfer.landingPoint?.carrierCell.id,
        landingPointUnitsCellId: transfer.landingPoint?.unitsCell.id,
        gatheringPointCarrierCellId: transfer.gatheringPoint?.carrierCell.id,
        gatheringPointUnitsCellId: transfer.gatheringPoint?.unitsCell.id,
      );

  SaveSettingsStorageDbEntity _mapSettingsToDbEntity(
    GameFieldSettingsStorageRead settings, {
    required int slotDbId,
  }) =>
      SaveSettingsStorageDbEntity(
        slotDbId: slotDbId,
        zoom: settings.zoom,
        cameraPositionX: settings.cameraPosition?.x,
        cameraPositionY: settings.cameraPosition?.y,
      );
}
