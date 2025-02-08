import 'package:collection/collection.dart';
import 'package:trench_warfare/core/entities/map_metadata/map_metadata_record.dart';
import 'package:trench_warfare/core/enums/aggressiveness.dart';
import 'package:trench_warfare/screens/new_game/model/dto/map_selection_dto_library.dart';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:trench_warfare/shared/data/map_decoder.dart';
import 'package:trench_warfare/shared/helpers/extensions.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';
import 'package:tuple/tuple.dart';

class MapsDataLoader {
  List<String>? _allAssets;

  Future<MapTabDto> loadTab(String filter, TabCode tabCode, {required bool selected}) async {
    final mapsFileNames = (await _getAllAssets()).where((m) => m.contains(filter)).toList(growable: false);

    final cards = <MapCardDto>[];

    for (var i = 0; i < mapsFileNames.length; i++) {
      final mapFileName = mapsFileNames[i];

      final mapFile = await MapDecoder.openFile(mapFileName);

      final metadataRecord = mapFile.getMetadata();
      final mapSize = mapFile.getSize();

      if (metadataRecord != null) {
        cards.add(
          _metadataToCard(
            metadata: metadataRecord,
            mapFileName: mapFileName,
            tabCode: tabCode,
            mapSize: mapSize,
            index: i,
            selected: i == 0,
          ),
        );
      } else {
        Logger.warn('Can\'t extract metadata for the next map: $mapFileName');
      }
    }

    return MapTabDto(
      code: tabCode,
      selected: selected,
      cards: cards.sorted((c1, c2) => c1.from.compareTo(c2.from)),
    );
  }

  Future<List<String>> _getAllAssets() async {
    if (_allAssets == null) {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      _allAssets = manifest.listAssets();
    }

    return _allAssets!;
  }

  /// [mapSize] weight and height of the map (in cells)
  MapCardDto _metadataToCard({
    required MapMetadataRecord metadata,
    required String mapFileName,
    required TabCode tabCode,
    required Tuple2<int, int> mapSize,
    required int index,
    required bool selected,
  }) {
    final mapName = mapFileName.replaceFirst('.tmx', '').let((s) => s.substring(s.lastIndexOf('/') + 1))!;

    final opponents = metadata.nations
        .where((n) => n.aggressiveness == Aggressiveness.aggressive)
        .mapIndexed((i, n) => SideOfConflictDto(nation: n.code, selected: i == 0))
        .toList(growable: false);

    final neutrals = metadata.nations
        .where((n) => n.aggressiveness != Aggressiveness.aggressive)
        .map((n) => n.code)
        .toList(growable: false);

    return MapCardDto(
      id: '${tabCode.name}_$index',
      mapName: mapName,
      mapFileName: mapFileName,
      title: metadata.title,
      from: metadata.from,
      to: metadata.to,
      description: metadata.description,
      opponents: opponents,
      neutrals: neutrals,
      selected: selected,
      mapRows: mapSize.item2,
      mapCols: mapSize.item1,
    );
  }
}
