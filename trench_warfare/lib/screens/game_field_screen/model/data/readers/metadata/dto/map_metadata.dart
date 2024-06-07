import 'package:trench_warfare/app/localization/locale.dart';
import 'package:trench_warfare/core_entities/enums/aggressiveness.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/relationship.dart';

abstract interface class MapMetadataRead {
  bool isInWar(Nation? nation1, Nation? nation2);

  List<Nation> getAllAggressive();
}

class MapMetadata implements MapMetadataRead {
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

  @override
  bool isInWar(Nation? nation1, Nation? nation2) {
    if (nation1 == null || nation2 == null) {
      return false;
    }

    if (nation1 == nation2) {
      return false;
    }

    return diplomacy
            .singleWhere((e) =>
                (e.firstNation == nation1 && e.secondNation == nation2) ||
                (e.firstNation == nation2 && e.secondNation == nation1))
            .relationship ==
        Relationship.war;
  }

  @override
  List<Nation> getAllAggressive() => nations
      .where((n) => n.aggressiveness == Aggressiveness.aggressive)
      .map((n) => n.code)
      .toList(growable: false);
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
