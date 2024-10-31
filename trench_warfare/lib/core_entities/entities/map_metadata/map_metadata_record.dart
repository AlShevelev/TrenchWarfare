import 'package:trench_warfare/core_entities/enums/aggressiveness.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/relationship.dart';
import 'package:trench_warfare/core_entities/localization/app_locale.dart';

class MapMetadataRecord {
  final int version;
  final Map<AppLocale, String> title;
  final Map<AppLocale, String> description;
  final List<NationRecord> nations;
  final List<DiplomacyRecord> diplomacy;
  final DateTime from;
  final DateTime to;

  MapMetadataRecord({
    required this.version,
    required this.title,
    required this.description,
    required this.nations,
    required this.diplomacy,
    required this.from,
    required this.to,
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
