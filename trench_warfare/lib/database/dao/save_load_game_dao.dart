import 'package:trench_warfare/database/dao/dao_base.dart';
import 'package:trench_warfare/database/entities/save_game_field_cell_db_entity.dart';
import 'package:trench_warfare/database/entities/save_nation_db_entity.dart';
import 'package:trench_warfare/database/entities/save_settings_storage_db_entity.dart';
import 'package:trench_warfare/database/entities/save_slot_db_entity.dart';
import 'package:trench_warfare/database/entities/save_troop_transfer_db_entity.dart';
import 'package:trench_warfare/database/entities/save_unit_db_entity.dart';
import 'package:trench_warfare/database/objectbox.g.dart';

class SaveLoadGameDao extends DaoBase {
  final Box<SaveGameFieldCellDbEntity> _cellBox;
  final Box<SaveNationDbEntity> _nationBox;
  final Box<SaveSettingsStorageDbEntity> _settingsStorageBox;
  final Box<SaveSlotDbEntity> _slotBox;
  final Box<SaveTroopTransferDbEntity> _troopTransferBox;
  final Box<SaveUnitDbEntity> _unitBox;

  SaveLoadGameDao({
    required Box<SaveGameFieldCellDbEntity> cellBox,
    required Box<SaveNationDbEntity> nationBox,
    required Box<SaveSettingsStorageDbEntity> settingsStorageBox,
    required Box<SaveSlotDbEntity> slotBox,
    required Box<SaveTroopTransferDbEntity> troopTransferBox,
    required Box<SaveUnitDbEntity> unitBox,
  })  : _cellBox = cellBox,
        _nationBox = nationBox,
        _settingsStorageBox = settingsStorageBox,
        _slotBox = slotBox,
        _troopTransferBox = troopTransferBox,
        _unitBox = unitBox;

  void createSlot(SaveSlotDbEntity entity) => put(_slotBox, entity);

  void createCell(SaveGameFieldCellDbEntity entity) => put(_cellBox, entity);

  void createNation(SaveNationDbEntity entity) => put(_nationBox, entity);

  void createSettings(SaveSettingsStorageDbEntity entity) => put(_settingsStorageBox, entity);

  void createTroopTransfer(SaveTroopTransferDbEntity entity) => put(_troopTransferBox, entity);

  void createUnit(SaveUnitDbEntity entity) => put(_unitBox, entity);

  List<SaveSlotDbEntity> readAllSlots() => read(_slotBox.query().order(SaveSlotDbEntity_.slotNumber));

  SaveSlotDbEntity? readSlot(int slotNumber) =>
      readFirst(_slotBox.query(SaveSlotDbEntity_.slotNumber.equals(slotNumber)));

  List<SaveGameFieldCellDbEntity> readAllCells(int slotDbId) =>
      read(_cellBox.query(SaveGameFieldCellDbEntity_.slotDbId.equals(slotDbId)));

  List<SaveNationDbEntity> readAllNations(int slotDbId) => read(_nationBox
      .query(SaveNationDbEntity_.slotDbId.equals(slotDbId))
      .order(SaveNationDbEntity_.playingOrder));

  List<SaveSettingsStorageDbEntity> readAllSettings(int slotDbId) =>
      read(_settingsStorageBox.query(SaveSettingsStorageDbEntity_.slotDbId.equals(slotDbId)));

  List<SaveTroopTransferDbEntity> readAllTroopTransfers(int slotDbId) =>
      read(_troopTransferBox.query(SaveTroopTransferDbEntity_.slotDbId.equals(slotDbId)));

  List<SaveUnitDbEntity> readAllUnits(int slotDbId) =>
      read(_unitBox.query(SaveUnitDbEntity_.slotDbId.equals(slotDbId)));

  void deleteSlot(int slotNumber) {
    final slotDbId = readSlot(slotNumber)!.dbId;

    remove(_slotBox.query(SaveSlotDbEntity_.dbId.equals(slotDbId)));
    remove(_cellBox.query(SaveGameFieldCellDbEntity_.slotDbId.equals(slotDbId)));
    remove(_nationBox.query(SaveNationDbEntity_.slotDbId.equals(slotDbId)));
    remove(_settingsStorageBox.query(SaveSettingsStorageDbEntity_.slotDbId.equals(slotDbId)));
    remove(_troopTransferBox.query(SaveTroopTransferDbEntity_.slotDbId.equals(slotDbId)));
    remove(_unitBox.query(SaveUnitDbEntity_.slotDbId.equals(slotDbId)));
  }
}
