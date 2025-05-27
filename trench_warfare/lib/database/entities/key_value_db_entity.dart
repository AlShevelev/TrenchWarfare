/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

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
