import 'package:trench_warfare/core_entities/enums/aggressiveness.dart';
import 'package:trench_warfare/core_entities/enums/relationship.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';

class MetadataValidator {
  static void validate(MapMetadata metadata) {
    _validateTitleAndDescription(metadata);
    _validateNationsQuantity(metadata);
    _validateNationsAggressiveness(metadata);
    _validateNationsWarState(metadata);
  }

  // Title and description must be filled in the metadata
  static void _validateTitleAndDescription(MapMetadata metadata) {
    if (metadata.title.isEmpty) {
      throw ArgumentError("Title and description must be filled in the metadata");
    }

    if (metadata.description.isEmpty) {
      throw ArgumentError("Title and description must be filled in the metadata");
    }
  }

  // The metadata must contain two different nations at least
  static void _validateNationsQuantity(MapMetadata metadata) {
    if (metadata.nations.map((e) => e.code).toSet().length < 2) {
      throw ArgumentError("The metadata must contain two different nations at least");
    }
  }

  // The metadata must contain two different aggressive nations at least
  static void _validateNationsAggressiveness(MapMetadata metadata) {
    final nations = metadata.nations.map((e) => e.code).toSet();
    var aggressive = 0;

    for (var nation in nations) {
      if (metadata.nations.singleWhere((e) => e.code == nation).aggressiveness == Aggressiveness.aggressive) {
        aggressive++;
      }
    }

    if (aggressive < 2) {
      throw ArgumentError("The metadata must contain two different aggressive nations at least");
    }
  }

  // The metadata must contain two aggressive nations at war at least
  static void _validateNationsWarState(MapMetadata metadata) {
    final aggressiveNations =
        metadata.nations.where((e) => e.aggressiveness == Aggressiveness.aggressive).map((e) => e.code).toSet();

    final warNations = metadata.diplomacy.where((e) => e.relationship == Relationship.war);

    var wars = 0;

    for (var warNation in warNations) {
      if (warNation.firstNation == warNation.secondNation) {
        throw ArgumentError("A [${warNation.firstNation}] can't be at war state with itself");
      }

      if (aggressiveNations.contains(warNation.firstNation) && aggressiveNations.contains(warNation.secondNation)) {
        wars++;
      }
    }

    if (wars == 0) {
      throw ArgumentError("The metadata must contain two aggressive nations at war at least");
    }
  }
}
