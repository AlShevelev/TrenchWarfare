import 'package:trench_warfare/core_entities/entities/map_metadata/map_metadata_record.dart';
import 'package:trench_warfare/core_entities/enums/aggressiveness.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/relationship.dart';
import 'package:trench_warfare/core_entities/localization/app_locale.dart';

abstract interface class MapMetadataRead {
  bool isInWar(Nation? nation1, Nation? nation2);

  List<Nation> getAllAggressive();

  List<Nation> getMyEnemies(Nation myNation);

  List<Nation> getMyNotEnemies(Nation myNation);

  List<Nation> getAll();
}

class MapMetadata implements MapMetadataRead {
  final MapMetadataRecord _record;

  int get version => _record.version;

  Map<AppLocale, String> get title => _record.title;

  Map<AppLocale, String> get description => _record.description;

  List<NationRecord> get nations => _record.nations;

  List<DiplomacyRecord> get diplomacy => _record.diplomacy;

  MapMetadata(MapMetadataRecord record): _record = record;

  @override
  bool isInWar(Nation? nation1, Nation? nation2) {
    if (nation1 == null || nation2 == null) {
      return false;
    }

    if (nation1 == nation2) {
      return false;
    }

    final relationship = diplomacy
            .singleWhere((e) =>
                (e.firstNation == nation1 && e.secondNation == nation2) ||
                (e.firstNation == nation2 && e.secondNation == nation1))
            .relationship;

    return relationship == Relationship.war;
  }

  @override
  List<Nation> getAllAggressive() => nations
      .where((n) => n.aggressiveness == Aggressiveness.aggressive)
      .map((n) => n.code)
      .toList(growable: false);

  @override
  List<Nation> getMyEnemies(Nation myNation) => nations
      .where((n) => n.code != myNation && isInWar(myNation, n.code))
      .map((n) => n.code)
      .toList(growable: false);

  @override
  List<Nation> getMyNotEnemies(Nation myNation) {
    final allEnemies = getMyEnemies(myNation);

    return nations
        .where((n) => n.code != myNation && !allEnemies.contains(n.code))
        .map((n) => n.code)
        .toList(growable: false);
  }

  @override
  List<Nation> getAll() => nations.map((n) => n.code).toList(growable: false);
}
