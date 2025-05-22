import 'package:trench_warfare/core/entities/map_metadata/map_metadata_record.dart';
import 'package:trench_warfare/core/enums/aggressiveness.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/relationship.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';

abstract interface class MapMetadataRead {
  bool get landOnlyAi;

  bool isInWar(Nation? nation1, Nation? nation2);

  bool isNeutral(Nation? nation1, Nation? nation2);

  bool isAlly(Nation? nation1, Nation? nation2);

  List<Nation> getAllAggressive();

  List<Nation> getEnemies(Nation myNation);

  List<Nation> getAllied(Nation myNation);

  List<Nation> getNeutral(Nation myNation);

  List<Nation> getAll();
}

class MapMetadata implements MapMetadataRead {
  final MapMetadataRecord _record;

  int get version => _record.version;

  Map<AppLocale, String> get title => _record.title;

  Map<AppLocale, String> get description => _record.description;

  List<NationRecord> get nations => _record.nations;

  List<DiplomacyRecord> get diplomacy => _record.diplomacy;

  @override
  bool get landOnlyAi => _record.landOnlyAi;

  MapMetadata(MapMetadataRecord record) : _record = record;

  @override
  bool isInWar(Nation? nation1, Nation? nation2) => _hasRelationship(nation1, nation2, Relationship.war);

  @override
  bool isNeutral(Nation? nation1, Nation? nation2) =>
      _hasRelationship(nation1, nation2, Relationship.neutral);

  @override
  bool isAlly(Nation? nation1, Nation? nation2) => _hasRelationship(nation1, nation2, Relationship.allied);

  @override
  List<Nation> getAllAggressive() => nations
      .where((n) => n.aggressiveness == Aggressiveness.aggressive)
      .map((n) => n.code)
      .toList(growable: false);

  @override
  List<Nation> getEnemies(Nation myNation) => nations
      .where((n) => n.code != myNation && isInWar(myNation, n.code))
      .map((n) => n.code)
      .toList(growable: false);

  @override
  List<Nation> getAllied(Nation myNation) => nations
      .where((n) => n.code != myNation && isAlly(myNation, n.code))
      .map((n) => n.code)
      .toList(growable: false);

  @override
  List<Nation> getNeutral(Nation myNation) => nations
      .where((n) => n.code != myNation && isNeutral(myNation, n.code))
      .map((n) => n.code)
      .toList(growable: false);

  @override
  List<Nation> getAll() => nations.map((n) => n.code).toList(growable: false);

  bool _hasRelationship(Nation? nation1, Nation? nation2, Relationship relationship) {
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
        relationship;
  }
}
