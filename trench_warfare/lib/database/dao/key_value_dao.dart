import 'package:trench_warfare/database/dao/dao_base.dart';
import 'package:trench_warfare/database/entities/key_value_db_entity.dart';
import 'package:trench_warfare/database/objectbox.g.dart';
import 'package:trench_warfare/shared/utils/extensions.dart';

class KeyValueDao extends DaoBase {
  final Box<KeyValueDbEntity> _box;

  KeyValueDao({required Box<KeyValueDbEntity> box}) : _box = box;

  /// Insert or update an existing object (with given key).
  void putInt(String key, int value) => putString(key, value.toString());

  /// Insert or update an existing object (with given key).
  void putDouble(String key, double value) => putString(key, value.toString());

  /// Insert or update an existing object (with given key).
  void putBool(String key, bool value) => putString(key, value.toString());

  /// Insert or update an existing object (with given key).
  void putString(String key, String value) {
    var dbRecord = readFirst(_getQuery(key));

    if (dbRecord == null) {
      dbRecord = KeyValueDbEntity(key: key, value: value);
    } else {
      dbRecord.value = value;
    }

    put(_box, dbRecord);
  }

  int? readInt(String key) => readString(key)?.let((r) => int.parse(r));

  double? readDouble(String key) => readString(key)?.let((r) => double.parse(r));

  String? readString(String key) => readFirst(_getQuery(key))?.value;

  bool? readBool(String key) => readString(key)?.let((r) => bool.parse(r));

  void delete(String key) => remove(_getQuery(key));

  QueryBuilder<KeyValueDbEntity> _getQuery(String key) =>
      _box.query(KeyValueDbEntity_.key.equals(key));
}
