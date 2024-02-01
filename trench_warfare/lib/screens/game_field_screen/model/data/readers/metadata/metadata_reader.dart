import 'dart:convert';

import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/app/localization/locale.dart';
import 'package:trench_warfare/core_entities/enums/aggressiveness.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/relationship.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/metadata_validator.dart';

class MetadataReader {
  static MapMetadata read(TiledMap map) {
    final metadata = _readMetadata(map);

    MetadataValidator.validate(metadata);

    return metadata;
  }

  static MapMetadata _readMetadata(TiledMap map) {
    final properties = map.properties.byName;
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

  static Map<Locale, String> _readLocale(Map<String, dynamic> metadata, String keyName) {
    final localeNames = Locale.values.asNameMap();
    return (metadata[keyName] as Map<String, dynamic>).map((key, value) => MapEntry(localeNames[key]!, value as String));
  }

  static List<NationRecord> _readNations(Map<String, dynamic> metadata) {
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

  static List<DiplomacyRecord> _readDiplomacy(Map<String, dynamic> metadata) {
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
