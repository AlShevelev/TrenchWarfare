import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/core_entities/enums/special_strike_type.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_boost.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';

class CardPhotos {
  static const _pathToImages = 'assets/images/game_field_overlays/cards/';

  static String getPhoto(GameFieldControlsCard card) =>
    _pathToImages + switch(card) {
      GameFieldControlsUnitCard() => switch(card.type) {
        UnitType.armoredCar => 'units/photo_armored_car.webp',
        UnitType.artillery => 'units/photo_artillery.webp',
        UnitType.infantry => 'units/photo_infantry.webp',
        UnitType.cavalry => 'units/photo_cavalry.webp',
        UnitType.machineGunnersCart => 'units/photo_machine_gunners_cart.webp',
        UnitType.machineGuns => 'units/photo_machine_gunners.webp',
        UnitType.tank => 'units/photo_tank.webp',
        UnitType.destroyer => 'units/photo_destroyer.webp',
        UnitType.cruiser => 'units/photo_cruiser.webp',
        UnitType.battleship => 'units/photo_battleship.webp',
        UnitType.carrier => 'units/photo_carrier.webp',
      },

    GameFieldControlsProductionCentersCard() => switch(card.type) {
      ProductionCenterType.city => 'production_centers/photo_city.webp',
      ProductionCenterType.factory => 'production_centers/photo_factory.webp',
      ProductionCenterType.airField => 'production_centers/photo_air_field.webp',
      ProductionCenterType.navalBase => 'production_centers/photo_naval_base.webp',
    },

    GameFieldControlsTerrainModifiersCard() => switch(card.type) {
      TerrainModifierType.seaMine => 'terrain_modifiers/photo_sea_mine_field.webp',
      TerrainModifierType.antiAirGun => 'terrain_modifiers/photo_anti_air_gun.webp',
      TerrainModifierType.landMine => 'terrain_modifiers/photo_land_mine_field.webp',
      TerrainModifierType.landFort => 'terrain_modifiers/photo_land_fort.webp',
      TerrainModifierType.barbedWire => 'terrain_modifiers/photo_barbed_wire.webp',
      TerrainModifierType.trench => 'terrain_modifiers/photo_trench.webp',
    },

    GameFieldControlsUnitBoostersCard() => switch(card.type) {
      UnitBoost.attack => 'troop_boosters/photo_attack.webp',
      UnitBoost.defence => 'troop_boosters/photo_defence.webp',
      UnitBoost.transport => 'troop_boosters/photo_transport.webp',
      UnitBoost.commander => 'troop_boosters/photo_commander.webp',
    },

    GameFieldControlsSpecialStrikesCard() => switch(card.type) {
      SpecialStrikeType.gasAttack => 'special_strikes/photo_gas_attack.webp',
      SpecialStrikeType.flechettes => 'special_strikes/photo_flechettes.webp',
      SpecialStrikeType.airBombardment => 'special_strikes/photo_air_bombing.webp',
      SpecialStrikeType.flameTroopers => 'special_strikes/photo_flametroopers.webp',
      SpecialStrikeType.propaganda => 'special_strikes/photo_propaganda.webp',
    },
    _ => throw UnsupportedError(''),
  };
}