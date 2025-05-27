/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:trench_warfare/core/enums/aggressiveness.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/relationship.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';

class MapMetadataRecord {
  final int version;
  final Map<AppLocale, String> title;
  final Map<AppLocale, String> description;
  final List<NationRecord> nations;
  final List<DiplomacyRecord> diplomacy;
  final DateTime from;
  final DateTime to;
  final bool landOnlyAi;

  MapMetadataRecord({
    required this.version,
    required this.title,
    required this.description,
    required this.nations,
    required this.diplomacy,
    required this.from,
    required this.to,
    required this.landOnlyAi,
  });
}

class NationRecord {
  final Nation code;
  final Aggressiveness aggressiveness;
  final int startMoney;
  final int startIndustryPoints;

  NationRecord({
    required this.code,
    required this.aggressiveness,
    required this.startMoney,
    required this.startIndustryPoints,
  });
}

class DiplomacyRecord {
  final Nation firstNation;
  final Nation secondNation;
  final Relationship relationship;

  DiplomacyRecord({
    required this.firstNation,
    required this.secondNation,
    required this.relationship,
  });
}
