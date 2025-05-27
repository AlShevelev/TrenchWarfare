/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of influence_map;

class InfluenceMapComputeData {
  final Nation myNation;

  final MapMetadataRead metadata;

  final GameFieldRead gameField;

  InfluenceMapComputeData({required this.myNation, required this.metadata, required this.gameField});
}