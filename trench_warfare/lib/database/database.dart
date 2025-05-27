/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:trench_warfare/database/dao/key_value_dao.dart';
import 'package:trench_warfare/database/dao/save_load_game_dao.dart';
import 'package:trench_warfare/database/dao/talker_history_dao.dart';
import 'package:trench_warfare/database/entities/key_value_db_entity.dart';
import 'package:trench_warfare/database/entities/save_game_field_cell_db_entity.dart';
import 'package:trench_warfare/database/entities/save_nation_db_entity.dart';
import 'package:trench_warfare/database/entities/save_settings_storage_db_entity.dart';
import 'package:trench_warfare/database/entities/save_slot_db_entity.dart';
import 'package:trench_warfare/database/entities/save_troop_transfer_db_entity.dart';
import 'package:trench_warfare/database/entities/save_unit_db_entity.dart';
import 'package:trench_warfare/database/entities/talker_history_db_entity.dart';
import 'package:trench_warfare/database/objectbox.g.dart';

class Database {
  static late final Store _store;

  static final TalkerHistoryDao talkerHistoryDao = TalkerHistoryDao(box: Box<TalkerDataDbEntity>(_store));

  static final SaveLoadGameDao saveLoadGameDao = SaveLoadGameDao(
    cellBox: Box<SaveGameFieldCellDbEntity>(_store),
    nationBox: Box<SaveNationDbEntity>(_store),
    settingsStorageBox: Box<SaveSettingsStorageDbEntity>(_store),
    slotBox: Box<SaveSlotDbEntity>(_store),
    troopTransferBox: Box<SaveTroopTransferDbEntity>(_store),
    unitBox: Box<SaveUnitDbEntity>(_store),
  );

  static final KeyValueDao keyValueDao = KeyValueDao(box: Box<KeyValueDbEntity>(_store));

  static Future<void> start() async {
    _store = await openStore();
  }

  static void close() => _store.close();
}
