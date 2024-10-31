import 'package:collection/collection.dart';
import 'package:trench_warfare/core_entities/entities/map_metadata/map_metadata_record.dart';
import 'package:trench_warfare/core_entities/enums/aggressiveness.dart';
import 'package:trench_warfare/screens/new_game/model/dto/map_selection_dto_library.dart';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:trench_warfare/shared/data/map_metadata_decoder.dart';
import 'package:trench_warfare/shared/helpers/extensions.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

class MapsDataLoader {
  List<String>? _allAssets;

  Future<Tab> loadTab(String filter) async {
    final mapsFileNames = (await _getAllAssets()).where((m) => m.contains(filter)).toList(growable: false);

    final cards = <Card>[];

    for (var i = 0; i < mapsFileNames.length; i++) {
      final mapFileName = mapsFileNames[i];

      final rawMetadata = await _extractMetadata(mapFileName);

      if (rawMetadata != null) {
        final metadataRecord = MapMetadataDecoder.decode(rawMetadata);
        cards.add(
          _metadataToCard(
            metadataRecord,
            mapFileName,
            selected: i == 0,
          ),
        );
      } else {
        Logger.warn('Can\'t extract metadata for the next map: $mapFileName');
      }
    }

    return Tab(selected: false, cards: cards.sorted((c1, c2) => c1.from.compareTo(c2.from)));
  }

  Future<List<String>> _getAllAssets() async {
    if (_allAssets == null) {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      _allAssets = manifest.listAssets();
    }

    return _allAssets!;
  }

  Future<String?> _extractMetadata(String mapFileName) async {
    final rawText = await rootBundle.loadString(mapFileName);

    final document = XmlDocument.parse(rawText);
    final nodes = document.xpath('/map/properties/property[@name = "metadata"]');
    final rawMetadata = nodes.firstOrNull?.getAttribute('value');

    return rawMetadata;
  }

  Card _metadataToCard(
    MapMetadataRecord metadata,
    String mapFileName, {
    required bool selected,
  }) {
    final id = mapFileName.replaceFirst('.tmx', '').let((s) => s.substring(s.lastIndexOf('/') + 1))!;

    final opponents = metadata.nations
        .where((n) => n.aggressiveness == Aggressiveness.aggressive)
        .mapIndexed((i, n) => SideOfConflict(nation: n.code, selected: i == 0))
        .toList(growable: false);

    final neutrals = metadata.nations
        .where((n) => n.aggressiveness != Aggressiveness.aggressive)
        .map((n) => n.code)
        .toList(growable: false);

    return Card(
      id: id,
      title: metadata.description,
      from: metadata.from,
      to: metadata.to,
      description: metadata.description,
      opponents: opponents,
      neutrals: neutrals,
      selected: selected,
    );
  }
}
