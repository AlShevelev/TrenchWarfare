import 'package:trench_warfare/database/entities/talker_history_db_entity.dart';
import 'package:trench_warfare/database/objectbox.g.dart';

class TalkerHistoryDao {
  final Box<TalkerDataDbEntity> _box;

  TalkerHistoryDao({required Box<TalkerDataDbEntity> box}) : _box = box;

  void create(TalkerDataDbEntity item) => _box.put(item, mode: PutMode.insert);

  List<TalkerDataDbEntity> readAll() {
    final query = _box.query().order(TalkerDataDbEntity_.id).build();
    final result = query.find();
    query.close();

    return result;
  }

  void deleteAll() => _box.removeAll();
}