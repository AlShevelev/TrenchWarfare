part of influence_map;

class InfluenceMapComputeData {
  final Nation myNation;

  final MapMetadataRead metadata;

  final GameFieldRead gameField;

  InfluenceMapComputeData({required this.myNation, required this.metadata, required this.gameField});
}