import 'package:trench_warfare/app/localization/locale.dart';
import 'package:trench_warfare/core_entities/aggressiveness.dart';
import 'package:trench_warfare/core_entities/nation.dart';
import 'package:trench_warfare/core_entities/relationship.dart';

class MapMetadata {
  final int version;
  final Map<Locale, String> title;
  final Map<Locale, String> description;
  final List<NationRecord> nations;
  final List<DiplomacyRecord> diplomacy;

  MapMetadata({
    required this.version,
    required this.title,
    required this.description,
    required this.nations,
    required this.diplomacy,
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
