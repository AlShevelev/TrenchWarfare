import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:trench_warfare/core/entities/map_metadata/map_metadata_record.dart';
import 'package:trench_warfare/core/enums/aggressiveness.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/relationship.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/shared/utils/extensions.dart';
import 'package:tuple/tuple.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

abstract interface class MapDataExtractor {
  MapMetadataRecord? getMetadata();

  /// Returns weight and height of the map (in cells)
  Tuple2<int, int> getSize();
}

class MapDecoder implements MapDataExtractor {
  final XmlDocument _mapAsDocument;

  MapDecoder._(XmlDocument mapAsDocument): _mapAsDocument = mapAsDocument;

  static Future<MapDataExtractor> openFile(String mapFileName) async {
    final content = await _extractContentAsXml(mapFileName);
    return MapDecoder._(content);
  }

  @override
  MapMetadataRecord? getMetadata() {
    final nodes = _mapAsDocument.xpath('/map/properties/property[@name = "metadata"]');
    final rawMetadata = nodes.firstOrNull?.getAttribute('value');

    return rawMetadata?.let((m) => decodeMetadataFromRawString(m));
  }

  @override
  Tuple2<int, int> getSize() {
    final nodes = _mapAsDocument.xpath('/map');
    final width = int.parse(nodes.first.getAttribute('width')!);
    final height = int.parse(nodes.first.getAttribute('height')!);

    return Tuple2<int, int>(width, height);
  }

  static MapMetadataRecord decodeMetadataFromRawString(String rawMetadataString) {
    final decodedMetadata = jsonDecode(rawMetadataString) as Map<String, dynamic>;

    final dates = decodedMetadata['dates'] as Map<String, dynamic>?;
    final from = dates?.let((d) => DateTime.parse(d['from'] as String)) ?? DateTime.now();
    final to = dates?.let((d) => DateTime.parse(d['to'] as String)) ?? DateTime.now();

    return MapMetadataRecord(
      version: decodedMetadata['version'] as int,
      title: _readLocale(decodedMetadata, 'title'),
      description: _readLocale(decodedMetadata, 'description'),
      nations: _readNations(decodedMetadata),
      diplomacy: _readDiplomacy(decodedMetadata),
      from: from,
      to: to,
    );
  }

  static Map<AppLocale, String> _readLocale(Map<String, dynamic> metadata, String keyName) {
    final localeNames = AppLocale.values.asNameMap();
    return (metadata[keyName] as Map<String, dynamic>)
        .map((key, value) => MapEntry(localeNames[key]!, value as String));
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

  static Future<XmlDocument> _extractContentAsXml(String mapFileName) async {
    final rawText = await rootBundle.loadString(mapFileName);

    return XmlDocument.parse(rawText);
  }
}
