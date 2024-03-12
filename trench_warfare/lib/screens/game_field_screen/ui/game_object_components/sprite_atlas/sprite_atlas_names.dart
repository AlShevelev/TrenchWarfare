import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/path_item_type.dart';
import 'package:trench_warfare/core_entities/enums/production_center_level.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_boost.dart';
import 'package:trench_warfare/core_entities/enums/unit_experience_rank.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/shared/utils/range.dart';

/// Returns a sprite name from the sprite atlas
class SpriteAtlasNames {
  static String? getUnitQuantity(int? unitsTotal) => unitsTotal != null ? 'Unit-Quantity-$unitsTotal' : null;

  static String getUnitHealth(Unit unit) {
    final relativeHealth = unit.health / unit.maxHealth;

    final healthSuffix = Range(0.0, 0.05).isInRange(relativeHealth)
        ? 5
        : Range(0.05, 0.10).isInRange(relativeHealth)
        ? 10
        : Range(0.10, 0.15).isInRange(relativeHealth)
        ? 15
        : Range(0.15, 0.20).isInRange(relativeHealth)
        ? 20
        : Range(0.20, 0.25).isInRange(relativeHealth)
        ? 25
        : Range(0.25, 0.30).isInRange(relativeHealth)
        ? 30
        : Range(0.30, 0.35).isInRange(relativeHealth)
        ? 35
        : Range(0.35, 0.40).isInRange(relativeHealth)
        ? 40
        : Range(0.40, 0.45).isInRange(relativeHealth)
        ? 45
        : Range(0.45, 0.50).isInRange(relativeHealth)
        ? 50
        : Range(0.50, 0.55).isInRange(relativeHealth)
        ? 55
        : Range(0.55, 0.60).isInRange(relativeHealth)
        ? 60
        : Range(0.60, 0.65).isInRange(relativeHealth)
        ? 65
        : Range(0.65, 0.70).isInRange(relativeHealth)
        ? 70
        : Range(0.70, 0.75).isInRange(relativeHealth)
        ? 75
        : Range(0.75, 0.80).isInRange(relativeHealth)
        ? 80
        : Range(0.80, 0.85).isInRange(relativeHealth)
        ? 85
        : Range(0.85, 0.90).isInRange(relativeHealth)
        ? 90
        : Range(0.90, 0.95).isInRange(relativeHealth)
        ? 95
        : 100;
    return 'Unit-Health-$healthSuffix';
  }

  static String? getUnitExperienceRank(Unit unit) => switch (unit.experienceRank) {
      UnitExperienceRank.rookies => null,
      UnitExperienceRank.fighters => unit.isLand ? 'Unit-Land-Rank-2' : 'Unit-Sea-Rank-2',
      UnitExperienceRank.proficients => unit.isLand ? 'Unit-Land-Rank-3' : 'Unit-Sea-Rank-3',
      UnitExperienceRank.veterans => unit.isLand ? 'Unit-Land-Rank-4' : 'Unit-Sea-Rank-4',
      UnitExperienceRank.elite => unit.isLand ? 'Unit-Land-Rank-5' : 'Unit-Sea-Rank-5',
    };

  static String? getUnitBoost1(Unit unit) => switch (unit.boost1) {
      null => null,
      UnitBoost.attack => unit.isLand ? 'Unit-Boost-1-Attack' : 'Unit-Boost-0-Attack',
      UnitBoost.defence => unit.isLand ? 'Unit-Boost-1-Defence' : 'Unit-Boost-0-Defence',
      UnitBoost.commander => unit.isLand ? 'Unit-Boost-1-Commander' : 'Unit-Boost-0-Commander',
      UnitBoost.transport => unit.isLand ? 'Unit-Boost-1-Transport' : null,
    };

  static String? getUnitBoost2(Unit unit) => switch (unit.boost2) {
    null => null,
    UnitBoost.attack => unit.isLand ? 'Unit-Boost-2-Attack' : 'Unit-Boost-1-Attack',
    UnitBoost.defence => unit.isLand ? 'Unit-Boost-2-Defence' : 'Unit-Boost-1-Defence',
    UnitBoost.commander => unit.isLand ? 'Unit-Boost-2-Commander' : 'Unit-Boost-1-Commander',
    UnitBoost.transport => unit.isLand ? 'Unit-Boost-2-Transport' : null,
  };

  static String? getUnitBoost3(Unit unit) => switch (unit.boost3) {
    null => null,
    UnitBoost.attack => unit.isLand ? 'Unit-Boost-3-Attack' : 'Unit-Boost-2-Attack',
    UnitBoost.defence => unit.isLand ? 'Unit-Boost-3-Defence' : 'Unit-Boost-2-Defence',
    UnitBoost.commander => unit.isLand ? 'Unit-Boost-3-Commander' : 'Unit-Boost-2-Commander',
    UnitBoost.transport => unit.isLand ? 'Unit-Boost-3-Transport' : null,
  };

  static String? getUnitPrimary(Unit unit, Nation? nation) => switch (unit.type) {
    UnitType.armoredCar => 'Unit-Armored-car',
    UnitType.artillery => 'Unit-Artillery',
    UnitType.infantry || UnitType.cavalry => switch (nation) {
      null => null,
      Nation.austriaHungary => 'Unit-Austro-Hungarian-Infantry',
      Nation.belgium => 'Unit-Belgia-Infantry',
      Nation.bulgaria => 'Unit-Bulgaria-Infantry',
      Nation.china => 'Unit-China-Infantry',
      Nation.france => 'Unit-France-Infantry',
      Nation.germany => 'Unit-Germany-Infantry',
      Nation.greatBritain => 'Unit-UK-Infantry',
      Nation.greece => 'Unit-Greece-Infantry',
      Nation.italy => 'Unit-Italy-Infantry',
      Nation.japan => 'Unit-Japan-Infantry',
      Nation.korea => 'Unit-Korea-Infantry',
      Nation.mexico => 'Unit-Mexico-Infantry',
      Nation.mongolia => 'Unit-Mongolia-Infantry',
      Nation.montenegro => 'Unit-Montenegro-Infantry',
      Nation.romania => 'Unit-Romania-Infantry',
      Nation.russia => 'Unit-Russia-Infantry',
      Nation.serbia => 'Unit-Serbia-Infantry',
      Nation.turkey => 'Unit-Turkey-Infantry',
      Nation.usa => 'Unit-US-Infantry',
      Nation.usNorth => 'Unit-US-North-Infantry',
      Nation.usSouth => 'Unit-US-South-Infantry',
    },
    UnitType.machineGunnersCart => 'Unit-Machine-gunners-cart',
    UnitType.machineGuns => 'Unit-Machine-gunners',
    UnitType.tank => 'Unit-Tank',
    UnitType.destroyer => 'Unit-Destroyer',
    UnitType.cruiser => 'Unit-Cruiser',
    UnitType.battleship => 'Unit-Battleship',
    UnitType.carrier => 'Unit-Carrier',
  };

  static String? getUnitSecondary(Unit unit) => unit.type == UnitType.cavalry ? 'Unit-Cavalry-Horse' : null;

  static String getTerrainModifier(TerrainModifierType type) => switch (type) {
    TerrainModifierType.antiAirGun => 'Terrain-modifiers-anti-air-gun',
    TerrainModifierType.barbedWire => 'Terrain-modifiers-wire',
    TerrainModifierType.landFort => 'Terrain-modifiers-land-fort',
    TerrainModifierType.landMine => 'Terrain-modifiers-land-mine',
    TerrainModifierType.seaMine => 'Terrain-modifiers-sea-mine',
    TerrainModifierType.trench => 'Terrain-modifiers-trench',
  };

  static String getProductionCenter(ProductionCenter productionCenter) {
    final levelDigit = _getProductionCenterLevelDigit(productionCenter);

    return switch (productionCenter.type) {
      ProductionCenterType.airField => 'Production-centers-air-field-level-$levelDigit',
      ProductionCenterType.navalBase => 'Production-centers-naval-base-level-$levelDigit',
      ProductionCenterType.factory => 'Production-centers-factory-level-$levelDigit',
      ProductionCenterType.city => 'Production-centers-city-level-$levelDigit',
    };
  }

  static String getProductionCenterLevel(ProductionCenter productionCenter) =>
      'Production-centers-level-${_getProductionCenterLevelDigit(productionCenter)}';

  static String getSelectionFrame() => 'Selection-Frame';

  static String getNationBanner(Nation nation) {
    final nationSuffix = switch (nation) {
      Nation.austriaHungary => 'Austro-Hungaria',
      Nation.belgium => 'Belgium',
      Nation.bulgaria => 'Bulgaria',
      Nation.china => 'China',
      Nation.france => 'France',
      Nation.germany => 'Germany',
      Nation.greatBritain => 'UK',
      Nation.greece => 'Greece',
      Nation.italy => 'Italy',
      Nation.japan => 'Japan',
      Nation.korea => 'Korea',
      Nation.mexico => 'Mexico',
      Nation.mongolia => 'Mongolia',
      Nation.montenegro => 'Montenegro',
      Nation.romania => 'Romania',
      Nation.russia => 'Russia',
      Nation.serbia => 'Serbia',
      Nation.turkey => 'Turkey',
      Nation.usa => 'US',
      Nation.usNorth => 'US-North',
      Nation.usSouth => 'US-South',
    };

    return 'Banner-$nationSuffix';
  }

  static String getPath(PathItemType type) => switch (type) {
    PathItemType.normal => 'Path-Normal',
    PathItemType.explosion => 'Path-Explosion',
    PathItemType.battle => 'Path-Battle',
    PathItemType.end => 'Path-End',
  };

  static String _getProductionCenterLevelDigit(ProductionCenter productionCenter) => switch (productionCenter.level) {
    ProductionCenterLevel.level1 => '1',
    ProductionCenterLevel.level2 => '2',
    ProductionCenterLevel.level3 => '3',
    ProductionCenterLevel.level4 => '4',
    ProductionCenterLevel.capital => '5',
  };
}