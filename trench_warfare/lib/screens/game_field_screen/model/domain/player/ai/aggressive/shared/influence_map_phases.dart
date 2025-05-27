/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of aggressive_ai_shared_library;

mixin InfluenceMapPhases {
  Future<InfluenceMapRepresentation> calculateFullInfluenceMap(
    Nation myNation,
    MapMetadataRead metadata,
    GameFieldRead gameField,
  ) => compute<InfluenceMapComputeData, InfluenceMapRepresentation>(
            (data) => InfluenceMapRepresentation(
          myNation: data.myNation,
          metadata: data.metadata,
        )..calculateFull(data.gameField),
        InfluenceMapComputeData(
          myNation: myNation,
          metadata: metadata,
          gameField: gameField,
        ));

  void updateInfluenceMap(InfluenceMapRepresentation map, List<UnitUpdateResultItem>? updateData) {
    // updates the influence map
    if (updateData != null) {
      Logger.info(
        'We need to update the influence map. Processing result has ${updateData.length} items',
        tag: 'INFLUENCE_MAP',
      );

      for (final resultItem in updateData) {
        Logger.info(resultItem.toString(), tag: 'INFLUENCE_MAP');
      }

      for (final resultItem in updateData) {
        if (resultItem.type == UnitUpdateResulType.before) {
          map.removeUnit(resultItem.unit, resultItem.nation, resultItem.cell);
        } else {
          map.addUnit(resultItem.unit, resultItem.nation, resultItem.cell);
        }
      }
    }
  }
}
