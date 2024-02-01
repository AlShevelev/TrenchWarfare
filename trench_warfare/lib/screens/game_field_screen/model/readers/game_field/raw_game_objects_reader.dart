import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/production_center_level.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_boost.dart';
import 'package:trench_warfare/core_entities/enums/unit_experience_rank.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/readers/game_field/dto/game_object_raw.dart';

extension _PropertyHelper on Map<String, Property<Object>> {
  double getFloat(String name) => (this[name] as FloatProperty).value;

  String getString(String name) => (this[name] as StringProperty).value;

  /// Returns an object id
  int? getObject(String name) {
    final objectId = (this[name] as ObjectProperty).value;
    return objectId != 0 ? objectId : null;
  }

  UnitBoost? getUnitBoost(String boostPropertyName) {
    final boostAsStr = getString(boostPropertyName);
    return boostAsStr == "" ? null : UnitBoost.values.byName(boostAsStr);
  }

  UnitExperienceRank getUnitExperienceRank(String rankPropertyName) =>
      UnitExperienceRank.values.byName(getString(rankPropertyName));
}

class RawGameObjectReader {
  static Map<int, GameObjectRaw> read(TiledMap map) {
    final gameObjectLayer = map.layerByName("GameObjects") as ObjectGroup;
    return Map<int, GameObjectRaw>.fromEntries(
        gameObjectLayer.objects.map((e) => _decodeGameObject(e)).map((e) => MapEntry(e.id, e)));
  }

  static GameObjectRaw _decodeGameObject(TiledObject tiledObject) {
    final type = tiledObject.type;

    switch (type) {
      case "ownership":
        return _decodeOwnership(tiledObject);
      case "unit":
        return _decodeUnit(tiledObject);
      case "city":
      case "factory":
      case "airField":
      case "navalBase":
        return _decodeProductionCenter(tiledObject);
      case "terrainModifier":
        return _decodeTerrainModifier(tiledObject);
      default:
        throw FormatException("Can't recognize next terrain type: $type");
    }
  }

  static GameObjectRaw _decodeOwnership(TiledObject tiledObject) {
    final properties = tiledObject.properties.byName;

    return CellOwnershipRaw(
      tiledObject.id,
      unit1Id: properties.getObject("unit1"),
      unit2Id: properties.getObject("unit2"),
      unit3Id: properties.getObject("unit3"),
      unit4Id: properties.getObject("unit4"),
      productionCenterId: properties.getObject("productionCenter"),
      terrainModifierId: properties.getObject("terrainModifier"),
      nation: Nation.values.byName(tiledObject.name),
      center: _calculateCenter(tiledObject),
    );
  }

  static GameObjectRaw _decodeUnit(TiledObject tiledObject) {
    final properties = tiledObject.properties.byName;

    final unitType = UnitType.values.byName(tiledObject.name);

    if (unitType == UnitType.carrier) {
      return CarrierRaw(
        tiledObject.id,
        unit1Id: properties.getObject("unit1"),
        unit2Id: properties.getObject("unit2"),
        unit3Id: properties.getObject("unit3"),
        unit4Id: properties.getObject("unit4"),
        boost1: properties.getUnitBoost("boost1"),
        boost2: properties.getUnitBoost("boost2"),
        boost3: properties.getUnitBoost("boost3"),
        experienceRank: properties.getUnitExperienceRank("experienceRank"),
        fatigue: properties.getFloat("fatigue"),
        health: properties.getFloat("health"),
        movementPoints: properties.getFloat("movementPoints"),
        unit: unitType,
        center: _calculateCenter(tiledObject),
      );
    } else {
      return UnitRaw(
        tiledObject.id,
        boost1: properties.getUnitBoost("boost1"),
        boost2: properties.getUnitBoost("boost2"),
        boost3: properties.getUnitBoost("boost3"),
        experienceRank: properties.getUnitExperienceRank("experienceRank"),
        fatigue: properties.getFloat("fatigue"),
        health: properties.getFloat("health"),
        movementPoints: properties.getFloat("movementPoints"),
        unit: unitType,
        center: _calculateCenter(tiledObject),
      );
    }
  }

  static GameObjectRaw _decodeProductionCenter(TiledObject tiledObject) {
    final properties = tiledObject.properties.byName;

    return ProductionCenterRaw(
      tiledObject.id,
      type: ProductionCenterType.values.byName(tiledObject.type),
      level: ProductionCenterLevel.values.byName(tiledObject.name),
      name: properties.getString("name"),
      center: _calculateCenter(tiledObject),
    );
  }

  static GameObjectRaw _decodeTerrainModifier(TiledObject tiledObject) => TerrainModifierRaw(
        tiledObject.id,
        type: TerrainModifierType.values.byName(tiledObject.name),
        center: _calculateCenter(tiledObject),
      );

  static Vector2 _calculateCenter(TiledObject tiledObject) => Vector2(
        tiledObject.x + tiledObject.width / 2,
        tiledObject.y - tiledObject.height / 2,
      );
}
