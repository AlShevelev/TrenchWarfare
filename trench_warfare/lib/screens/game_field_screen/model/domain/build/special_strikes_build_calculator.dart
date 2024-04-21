part of build_calculators;

class SpecialStrikesBuildCalculator {
  late final GameFieldRead _gameField;

  late final Nation _myNation;

  late final MapMetadataRead _mapMetadata;

  late final List<GameFieldCellRead> _allCellsWithMyAirFields;

  static const int _flechettesRadius = 5;
  static const int _airBombardmentRadius = 7;

  SpecialStrikesBuildCalculator(GameFieldRead gameField, Nation myNation, MapMetadataRead mapMetadata) {
    _gameField = gameField;
    _myNation = myNation;
    _mapMetadata = mapMetadata;

    _allCellsWithMyAirFields = _gameField.cells
        .where((c) => c.nation == _myNation && c.productionCenter?.type == ProductionCenterType.airField)
        .toList(growable: false);
  }

  BuildRestriction? getDisplayRestriction(SpecialStrikeType type) => switch (type) {
        SpecialStrikeType.propaganda || SpecialStrikeType.flameTroopers || SpecialStrikeType.gasAttack => null,
        SpecialStrikeType.airBombardment => ProductionCenterBuildRestriction(
            productionCenterType: ProductionCenterType.airField,
            productionCenterLevel: ProductionCenterLevel.level2,
          ),
        SpecialStrikeType.flechettes => ProductionCenterBuildRestriction(
            productionCenterType: ProductionCenterType.airField,
            productionCenterLevel: ProductionCenterLevel.level1,
          )
      };

  BuildRestriction getError(SpecialStrikeType type) => switch (type) {
        SpecialStrikeType.propaganda || SpecialStrikeType.flameTroopers || SpecialStrikeType.gasAttack => AppropriateUnit(),
        SpecialStrikeType.airBombardment =>
          _allCellsWithMyAirFields.any((c) => c.productionCenter?.level == ProductionCenterLevel.level2)
              ? AppropriateUnit()
              : ProductionCenterBuildRestriction(
                  productionCenterType: ProductionCenterType.airField,
                  productionCenterLevel: ProductionCenterLevel.level2,
                ),
        SpecialStrikeType.flechettes => _allCellsWithMyAirFields.isNotEmpty
            ? AppropriateUnit()
            : ProductionCenterBuildRestriction(
                productionCenterType: ProductionCenterType.airField,
                productionCenterLevel: ProductionCenterLevel.level1,
              )
      };

  bool canBuildOnCell(GameFieldCellRead cell, SpecialStrikeType type) {
    if (cell.activeUnit == null) {
      return false;
    }

    if (!_mapMetadata.isInWar(cell.nation, _myNation)) {
      return false;
    }

    switch (type) {
      case SpecialStrikeType.gasAttack:
        {
          return cell.isLand;
        }
      case SpecialStrikeType.flechettes:
        {
          if (!cell.isLand) {
            return false;
          }

          if (!cell.units.any((u) => !u.isMechanical)) {
            return false;
          }

          return _allCellsWithMyAirFields.any((afc) => _gameField.calculateDistance(afc, cell) <= _flechettesRadius);
        }
      case SpecialStrikeType.airBombardment:
        {
          return _allCellsWithMyAirFields
              .where((c) => c.productionCenter?.level == ProductionCenterLevel.level2)
              .any((afc) => _gameField.calculateDistance(afc, cell) <= _airBombardmentRadius);
        }
      case SpecialStrikeType.flameTroopers:
        {
          if (!cell.isLand) {
            return false;
          }

          return cell.units.any((u) => u.type == UnitType.infantry || u.type == UnitType.tank);
        }
      case SpecialStrikeType.propaganda:
        {
          return true;
        }
    }
  }

  bool canBuildOnGameField(SpecialStrikeType type) {
    for (var cell in _gameField.cells) {
      if (canBuildOnCell(cell, type)) {
        return true;
      }
    }

    return false;
  }

  List<GameFieldCellRead> getAllCellsToBuild(SpecialStrikeType type) =>
      _gameField.cells.where((c) => canBuildOnCell(c, type)).toList(growable: false);
}
