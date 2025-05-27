/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:trench_warfare/database/dao/dao_base.dart';
import 'package:trench_warfare/database/entities/talker_history_db_entity.dart';
import 'package:trench_warfare/database/objectbox.g.dart';

class TalkerHistoryDao extends DaoBase {
  final Box<TalkerDataDbEntity> _box;

  TalkerHistoryDao({required Box<TalkerDataDbEntity> box}) : _box = box;

  void create(TalkerDataDbEntity item) => _box.put(item, mode: PutMode.insert);

  List<TalkerDataDbEntity> readAll() => read(_box.query().order(TalkerDataDbEntity_.dbId));

  void deleteAll() => _box.removeAll();
}