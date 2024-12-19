import 'package:objectbox/objectbox.dart';

@Entity()
class KeyValueDbEntity {
  @Id()
  int dbId;

  String key;

  String value;

  KeyValueDbEntity({
    this.dbId = 0,
    required this.key,
    required this.value,
  });
}
