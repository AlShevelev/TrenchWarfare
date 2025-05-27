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
class TalkerDataDbEntity {
  @Id()
  int dbId;

  String? message;

  /// 0 - error; 1 - critical; 2 - info; 3 - debug; 4 - verbose; 5 - warning
  int? logLevel;

  String? title;

  String? key;

  int? penFColor;
  int? penBColor;

  @Property(type: PropertyType.date)
  DateTime time;

  String? stackTrace;

  TalkerDataDbEntity({
    this.dbId = 0,
    this.message,
    this.logLevel,
    this.title,
    this.key,
    required this.time,
    this.penFColor,
    this.penBColor,
    this.stackTrace,
  });
}