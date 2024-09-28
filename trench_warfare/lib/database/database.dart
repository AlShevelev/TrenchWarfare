import 'package:trench_warfare/database/dao/talker_history_dao.dart';
import 'package:trench_warfare/database/entities/talker_history_db_entity.dart';
import 'package:trench_warfare/database/objectbox.g.dart';

class Database {
  static late final Store _store;

  // ignore: unnecessary_late
  static late final TalkerHistoryDao talkerHistoryDao =
      TalkerHistoryDao(box: Box<TalkerDataDbEntity>(_store));

  static Future<void> start() async {
    _store = await openStore();
  }

  void close() => _store.close();
}
