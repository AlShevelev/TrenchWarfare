import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/dto/game_object_raw.dart';
import 'package:trench_warfare/shared/utils/math.dart';

class GameFieldAssembler {
  static GameField assemble(
    List<GameFieldCell> allCells,
    Map<int, GameObjectRaw> allGameObjects,
    Map<GameFieldCell, CellOwnershipRaw> cellOwnership,
  ) {
    final lastCell = allCells.last;

    final ownershipPolygons =
        allGameObjects.entries.map((e) => e.value).whereType<RegionOwnershipRaw>().toList();

    for (var cell in allCells) {
      final ownership = cellOwnership[cell];

      if (ownership != null) {
        cell.setNation(ownership.nation);

        if (ownership.productionCenterId != null) {
          cell.setProductionCenter(
              _mapProductionCenter(allGameObjects[ownership.productionCenterId]! as ProductionCenterRaw));
        }

        if (ownership.terrainModifierId != null) {
          cell.setTerrainModifier(
              _mapTerrainModifier(allGameObjects[ownership.terrainModifierId]! as TerrainModifierRaw));
        }

        cell.addUnits(_getUnits(
            allGameObjects, [ownership.unit1Id, ownership.unit2Id, ownership.unit3Id, ownership.unit4Id]));
      } else {
        final nation = _tryToFindOwnership(cell, ownershipPolygons);

        if (nation != null) {
          cell.setNation(nation);
        }
      }
    }

    return GameField(allCells, rows: lastCell.row + 1, cols: lastCell.col + 1);
  }

  static Nation? _tryToFindOwnership(GameFieldCell cell, List<RegionOwnershipRaw> ownerships) {
    for (var ownership in ownerships) {
      if (InGameMath.isPointInsideRect(cell.center, ownership.bounds)) {
        // fast check
        if (InGameMath.isPointInsidePolygon(cell.center, ownership.vertices)) {
          // exact check
          return ownership.nation;
        }
      }
    }

    return null;
  }

  static ProductionCenter _mapProductionCenter(ProductionCenterRaw raw) => ProductionCenter(
        type: raw.type,
        level: raw.level,
        name: {AppLocale.en: raw.nameEn, AppLocale.ru: raw.nameRu},
      );

  static TerrainModifier _mapTerrainModifier(TerrainModifierRaw raw) => TerrainModifier(type: raw.type);

  static Unit _mapUnit(Map<int, GameObjectRaw> allGameObjects, UnitRaw raw) {
    if (raw.unit != UnitType.carrier) {
      return Unit(
        boost1: raw.boost1,
        boost2: raw.boost2,
        boost3: raw.boost3,
        experienceRank: raw.experienceRank,
        fatigue: raw.fatigue,
        health: raw.health,
        movementPoints: raw.movementPoints,
        type: raw.unit,
        isInDefenceMode: raw.isInDefenceMode,
      );
    } else {
      final carrierRaw = raw as CarrierRaw;

      return Carrier(
          boost1: raw.boost1,
          boost2: raw.boost2,
          boost3: raw.boost3,
          fatigue: raw.fatigue,
          health: raw.health,
          movementPoints: raw.movementPoints,
          isInDefenceMode: raw.isInDefenceMode,
          units: _getUnits(allGameObjects,
              [carrierRaw.unit1Id, carrierRaw.unit2Id, carrierRaw.unit3Id, carrierRaw.unit4Id]));
    }
  }

  static List<Unit> _getUnits(Map<int, GameObjectRaw> allGameObjects, Iterable<int?> unitIds) => unitIds
      .where((e) => e != null)
      .map((e) => _mapUnit(allGameObjects, allGameObjects[e]! as UnitRaw))
      .toList(growable: true);
}
