part of influence_map;

class InfluenceMap extends HexMatrix<InfluenceMapItem> {
  InfluenceMap(super.cellsRaw, {required super.rows, required super.cols});
}