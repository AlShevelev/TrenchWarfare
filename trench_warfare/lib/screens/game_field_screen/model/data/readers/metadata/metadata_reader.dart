import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/metadata_validator.dart';
import 'package:trench_warfare/shared/data/map_decoder.dart';

class MetadataReader {
  static MapMetadata read(TiledMap map) {
    final metadata = _readMetadata(map);

    MetadataValidator.validate(metadata);

    return metadata;
  }

  static MapMetadata _readMetadata(TiledMap map) {
    final properties = map.properties.byName;
    final metadataJsonString = (properties['metadata'] as StringProperty).value;
    final data = MapDecoder.decodeMetadataFromRawString(metadataJsonString);
    return MapMetadata(data);
  }
}
