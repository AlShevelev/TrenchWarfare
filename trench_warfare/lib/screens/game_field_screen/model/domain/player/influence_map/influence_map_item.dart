part of influence_map;

abstract interface class InfluenceMapItemRead {
  double? getLand(Nation nation);

  double? getSea(Nation nation);

  double? getCarrier(Nation nation);

  bool hasAny(Nation nation);
}

class InfluenceMapItem extends HexMatrixItem implements InfluenceMapItemRead {
  final Map<Nation, double> _land = {};

  final Map<Nation, double> _sea = {};

  final Map<Nation, double> _carrier = {};

  InfluenceMapItem({required super.row, required super.col});

  @override
  double? getLand(Nation nation) => _land[nation];

  @override
  double? getSea(Nation nation) => _sea[nation];

  @override
  double? getCarrier(Nation nation) => _carrier[nation];

  void updateLand(double value, Nation nation) => _update(value, nation, _land);

  void updateSea(double value, Nation nation) => _update(value, nation, _sea);

  void updateCarrier(double value, Nation nation) => _update(value, nation, _carrier);

  void _update(double value, Nation nation, Map<Nation, double> map) {
    final currentValue = map[nation];
    map[nation] = currentValue == null ? value : currentValue + value;
  }

  @override
  bool hasAny(Nation nation) =>
      getLand(nation) != null || getSea(nation) != null || getCarrier(nation) != null;
}
