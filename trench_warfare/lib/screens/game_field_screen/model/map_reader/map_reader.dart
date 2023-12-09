import 'dart:convert';

import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/app/localization/locale.dart';
import 'package:trench_warfare/core_entities/aggressiveness.dart';
import 'package:trench_warfare/core_entities/nation.dart';
import 'package:trench_warfare/core_entities/relationship.dart';
import 'package:trench_warfare/screens/game_field_screen/model/map_reader/dto/map_metadata.dart';

class MapReader {
  late final TiledMap _map;

  MapReader(TiledMap map) {
    _map = map;
  }

  MapMetadata readMetadata() {
    final properties = _map.properties.byName;
    final metadataJsonString = (properties['metadata'] as StringProperty).value;

    final decodedMetadata = jsonDecode(metadataJsonString) as Map<String, dynamic>;

    return MapMetadata(
      version: decodedMetadata['version'] as int,
      title: _readLocale(decodedMetadata, 'title'),
      description: _readLocale(decodedMetadata, 'description'),
      nations: _readNations(decodedMetadata),
      diplomacy: _readDiplomacy(decodedMetadata),
    );
  }

  Map<Locale, String> _readLocale(Map<String, dynamic> metadata, String keyName) {
    final localeNames = Locale.values.asNameMap();
    return (metadata[keyName] as Map<String, dynamic>).map((key, value) => MapEntry(localeNames[key]!, value as String));
  }

  List<NationRecord> _readNations(Map<String, dynamic> metadata) {
    final nationNames = Nation.values.asNameMap();
    final aggressivenessNames = Aggressiveness.values.asNameMap();

    return (metadata['nations'] as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .map((e) => NationRecord(
              code: nationNames[e['code']]!,
              aggressiveness: aggressivenessNames[e['aggressiveness']]!,
              startMoney: e['startMoney'] as int,
              startIndustryPoints: e['startIndustryPoints'] as int,
            ))
        .toList();
  }

  List<DiplomacyRecord> _readDiplomacy(Map<String, dynamic> metadata) {
    final nationNames = Nation.values.asNameMap();
    final relationshipNames = Relationship.values.asNameMap();

    return (metadata['diplomacy'] as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .map((e) => DiplomacyRecord(
              firstNation: nationNames[e['firstNation']]!,
              secondNation: nationNames[e['secondNation']]!,
              relationship: relationshipNames[e['relationship']]!,
            ))
        .toList();
  }
}
