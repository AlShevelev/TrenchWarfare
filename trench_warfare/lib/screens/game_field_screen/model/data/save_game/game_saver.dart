import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/game_slot.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/database/database.dart';
import 'package:trench_warfare/database/entities/save_game_field_cell_db_entity.dart';
import 'package:trench_warfare/database/entities/save_nation_db_entity.dart';
import 'package:trench_warfare/database/entities/save_settings_storage_db_entity.dart';
import 'package:trench_warfare/database/entities/save_slot_db_entity.dart';
import 'package:trench_warfare/database/entities/save_troop_transfer_db_entity.dart';
import 'package:trench_warfare/database/entities/save_unit_db_entity.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/money_storage.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/ai/aggressive/phases/carriers/carriers_phase_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_storage/game_field_settings_storage.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';

abstract interface class GameSaverBuilder {
  void save();

  GameSaverBuilder addTroopTransfers(Map<Nation, Iterable<TroopTransferReadForSaving>> troopTransfers);

  GameSaverBuilder addMoney(Map<Nation, MoneyStorageRead> money);
}

class GameSaver implements GameSaverBuilder {
  late final _dao = Database.saveLoadGameDao;

  late final GameFieldRead _gameField;

  late final MapMetadataRead _metadata;

  final int _slotNumber;

  final String _mapFileName;

  final bool _isAutosave;

  final int _day;

  late final GameFieldSettingsStorageRead _settingsStorage;

  late final Iterable<Nation> _defeated;

  late final Iterable<Nation> _playingNations;

  late final Map<Nation, Iterable<TroopTransferReadForSaving>> _troopTransfers;

  late final Map<Nation, MoneyStorageRead> _money;

  final int _humanPlayerIndex;

  GameSaver._(
    GameSlot slot,
    String mapFileName,
    bool isAutosave,
    int day,
    int humanPlayerIndex,
    GameFieldRead gameField,
    MapMetadataRead metadata,
    GameFieldSettingsStorageRead settingsStorage,
    Iterable<Nation> defeated,
    Iterable<Nation> playingNations,
  )   : _slotNumber = slot.index,
        _mapFileName = mapFileName,
        _isAutosave = isAutosave,
        _day = day,
        _humanPlayerIndex = humanPlayerIndex,
        _gameField = gameField,
        _metadata = metadata,
        _settingsStorage = settingsStorage,
        _defeated = defeated,
        _playingNations = playingNations;

  static GameSaverBuilder start({
    required GameSlot slot,
    required String mapFileName,
    required bool isAutosave,
    required int day,
    required int humanPlayerIndex,
    required GameFieldRead gameField,
    required MapMetadataRead metadata,
    required GameFieldSettingsStorageRead settingsStorage,
    required Iterable<Nation> defeated,
    required Iterable<Nation> playingNations,
  }) {
    return GameSaver._(
      slot,
      mapFileName,
      isAutosave,
      day,
      humanPlayerIndex,
      gameField,
      metadata,
      settingsStorage,
      defeated,
      playingNations,
    );
  }

  @override
  void save() {
    Logger.info('Saving started', tag: 'GAME_SAVE_LOAD');

    // The old slot must be removed first
    _dao.deleteSlot(_slotNumber);

    // Creating a new slot
    final slotDbRecord = SaveSlotDbEntity(
      slotNumber: _slotNumber,
      mapFileName: _mapFileName,
      isAutosave: _isAutosave,
      rows: _gameField.rows,
      cols: _gameField.cols,
      saveDateTime: DateTime.now(),
    );
    final slotDbId = _dao.createSlot(slotDbRecord);

    // Saving the settings
    final dbSettings = _mapSettingsToDbEntity(_settingsStorage, slotDbId: slotDbId);
    _dao.createSettings(dbSettings);

    // Saving the playing nations
    // A link between a unit Id (String) and db's id of a transfer
    final Map<String, int> unitsInTransfers = {};

    final allAggressive = _metadata.getAllAggressive();
    for (var i = 0; i < _playingNations.length; i++) {
      final nation = _playingNations.elementAt(i);

      final moneyRecord = _money[nation]!;

      final isHuman = i == _humanPlayerIndex;
      final dbNation = SaveNationDbEntity(
        slotDbId: slotDbId,
        isHuman: isHuman,
        playingOrder: i,
        nation: nation.index,
        day: isHuman ? _day : _day - 1,       // There is still yesterday for an AI player
        defeated: _defeated.contains(nation),
        isSideOfConflict: allAggressive.contains(nation),
        totalSumCurrency: moneyRecord.totalSum.currency,
        totalSumIndustryPoints: moneyRecord.totalSum.industryPoints,
        totalIncomeCurrency: moneyRecord.totalIncome.currency,
        totalIncomeIndustryPoints: moneyRecord.totalIncome.industryPoints,
        totalExpensesCurrency: moneyRecord.totalExpenses.currency,
        totalExpensesIndustryPoints: moneyRecord.totalExpenses.industryPoints,
      );
      final nationDbId = _dao.createNation(dbNation);

      // Saving the nations' transfer
      final transfers = _troopTransfers[nation];
      if (transfers != null) {
        for (final transfer in transfers) {
          final transferRecord = _mapTransferToDbEntity(
            transfer,
            slotDbId: slotDbId,
            nationDbId: nationDbId,
          );

          final transferDbId = _dao.createTroopTransfer(transferRecord);

          for (final unit in transfer.transportingUnits) {
            unitsInTransfers[unit.id] = transferDbId;
          }
        }
      }
    }

    // Saving the game field
    for (final cell in _gameField.cells) {
      final dbCell = _mapCellToDbEntity(slotDbId: slotDbId, cell);

      final cellDbId = _dao.createCell(dbCell);

      // Saving units
      for (var i = 0; i < cell.units.length; i++) {
        final unit = cell.units.elementAt(i);

        final dbUnit = _mapUnitToDbEntity(
          unit,
          slotDbId: slotDbId,
          cellDbId: cellDbId,
          carrierDbId: null,
          troopTransferDbId: unitsInTransfers[unit.id],
          index: i,
        );

        final unitDbId = _dao.createUnit(dbUnit);

        // Saving carrier's units
        if (unit.type == UnitType.carrier) {
          final carrier = unit as Carrier;

          for (var j = 0; j < carrier.units.length; j++) {
            final carrierInsideUnit = carrier.units.elementAt(j);

            final dbCarrierInsideUnit = _mapUnitToDbEntity(
              carrierInsideUnit,
              slotDbId: slotDbId,
              cellDbId: null,
              carrierDbId: unitDbId,
              troopTransferDbId: unitsInTransfers[unit.id],
              index: j,
            );

            _dao.createUnit(dbCarrierInsideUnit);
          }
        }
      }
    }

    Logger.info('Saving completed', tag: 'GAME_SAVE_LOAD');
  }

  @override
  GameSaverBuilder addTroopTransfers(Map<Nation, Iterable<TroopTransferReadForSaving>> troopTransfers) {
    _troopTransfers = troopTransfers;
    return this;
  }

  @override
  GameSaverBuilder addMoney(Map<Nation, MoneyStorageRead> money) {
    _money = money;
    return this;
  }

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
        productionCenterName: _mapProductionCenterName(cell.productionCenter),
        terrainModifier: cell.terrainModifier?.type.index,
        pathItemType: cell.pathItem?.type.index,
        pathItemIsActive: cell.pathItem?.isActive,
        pathItemMovementPointsLeft: cell.pathItem?.movementPointsLeft,
      );

  String? _mapProductionCenterName(ProductionCenter? pc) {
    if (pc == null || pc.name.isEmpty) {
      return null;
    }

    return '${pc.name[AppLocale.en]}|${pc.name[AppLocale.ru]}';
  }

  SaveUnitDbEntity _mapUnitToDbEntity(
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
        isInDefenceMode: unit.isInDefenceMode,
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
