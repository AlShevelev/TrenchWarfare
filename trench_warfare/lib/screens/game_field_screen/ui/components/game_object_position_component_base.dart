library game_field_components;

import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:flame/text.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:trench_warfare/app/theme/colors.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/path_item_type.dart';
import 'package:trench_warfare/core_entities/enums/production_center_level.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_boost.dart';
import 'package:trench_warfare/core_entities/enums/unit_experience_rank.dart';
import 'package:trench_warfare/core_entities/enums/unit_state.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/shared/utils/range.dart';

part 'cell_game_object.dart';
part 'untied_unit_game_object.dart';

enum _SpriteSize {
  small,
  base,
  large,
}

abstract base class GameObjectPositionComponentBase  extends PositionComponent {
  @protected
  late final Vector2 _baseSize;
  @protected
  late final TextureAtlas _spritesAtlas;
  @protected
  late final Vector2 _position;

  @protected
  late final Vector2 _smallSize;
  @protected
  late final Vector2 _largeSize;

  GameObjectPositionComponentBase({
    required TextureAtlas spritesAtlas,
    required Vector2 position,
  }) {
    _spritesAtlas = spritesAtlas;
    _position = position;
    this.position = position;

    _baseSize = Vector2.all(64.0);
    _smallSize = _baseSize.scaled(0.85);
    _largeSize = _baseSize.scaled(1.15);
  }

  @override
  @mustCallSuper
  void onMount() {
    super.onMount();
    _addSprites();
  }

  @protected
  void _addSprites() {}

  @protected
  void _addUnitSprites({required Unit unit, required Nation? nation, required int? unitsTotal, bool alwaysEnabled = false,}) {
    final quantityName = unitsTotal != null ? 'Unit-Quantity-$unitsTotal' : null;

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
    final healthName = 'Unit-Health-$healthSuffix';

    final experienceRankName = switch (unit.experienceRank) {
      UnitExperienceRank.rookies => null,
      UnitExperienceRank.fighters => unit.isLand ? 'Unit-Land-Rank-2' : 'Unit-Sea-Rank-2',
      UnitExperienceRank.proficients => unit.isLand ? 'Unit-Land-Rank-3' : 'Unit-Sea-Rank-3',
      UnitExperienceRank.veterans => unit.isLand ? 'Unit-Land-Rank-4' : 'Unit-Sea-Rank-4',
      UnitExperienceRank.elite => unit.isLand ? 'Unit-Land-Rank-5' : 'Unit-Sea-Rank-5',
    };

    final boost1Name = switch (unit.boost1) {
      null => null,
      UnitBoost.attack => unit.isLand ? 'Unit-Boost-1-Attack' : 'Unit-Boost-0-Attack',
      UnitBoost.defence => unit.isLand ? 'Unit-Boost-1-Defence' : 'Unit-Boost-0-Defence',
      UnitBoost.commander => unit.isLand ? 'Unit-Boost-1-Commander' : 'Unit-Boost-0-Commander',
      UnitBoost.transport => unit.isLand ? 'Unit-Boost-1-Transport' : null,
    };

    final boost2Name = switch (unit.boost2) {
      null => null,
      UnitBoost.attack => unit.isLand ? 'Unit-Boost-2-Attack' : 'Unit-Boost-1-Attack',
      UnitBoost.defence => unit.isLand ? 'Unit-Boost-2-Defence' : 'Unit-Boost-1-Defence',
      UnitBoost.commander => unit.isLand ? 'Unit-Boost-2-Commander' : 'Unit-Boost-1-Commander',
      UnitBoost.transport => unit.isLand ? 'Unit-Boost-2-Transport' : null,
    };

    final boost3Name = switch (unit.boost3) {
      null => null,
      UnitBoost.attack => unit.isLand ? 'Unit-Boost-3-Attack' : 'Unit-Boost-2-Attack',
      UnitBoost.defence => unit.isLand ? 'Unit-Boost-3-Defence' : 'Unit-Boost-2-Defence',
      UnitBoost.commander => unit.isLand ? 'Unit-Boost-3-Commander' : 'Unit-Boost-2-Commander',
      UnitBoost.transport => unit.isLand ? 'Unit-Boost-3-Transport' : null,
    };

    final secondaryUnitName = unit.type == UnitType.cavalry ? 'Unit-Cavalry-Horse' : null;

    final primaryUnitName = switch (unit.type) {
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

    final state = alwaysEnabled ? UnitState.enabled : unit.state;
    if (state == UnitState.disabled) {
      _addSprite(primaryUnitName, decorator: _getDisabledDecorator(), size: _SpriteSize.base);
      _addSprite(secondaryUnitName, decorator: _getDisabledDecorator(), size: _SpriteSize.base);
    } else {
      if (state == UnitState.active) {
        _addSprite('Selection-Frame', size: _SpriteSize.base);
      }

      _addSprite(primaryUnitName, size: _SpriteSize.base);
      _addSprite(secondaryUnitName, size: _SpriteSize.base);
    }

    _addSprite(healthName, size: _SpriteSize.base);
    if (quantityName != null) {
      _addSprite(quantityName, size: _SpriteSize.base);
    }
    _addSprite(experienceRankName, size: _SpriteSize.base);
    _addSprite(boost1Name, size: _SpriteSize.base);
    _addSprite(boost2Name, size: _SpriteSize.base);
    _addSprite(boost3Name, size: _SpriteSize.base);
  }

  @protected
  void _addSprite(
      String? spriteName, {
        _SpriteSize size = _SpriteSize.small,
        Decorator? decorator,
      }) {
    if (spriteName == null) {
      return;
    }

    final componentSize = switch (size) {
      _SpriteSize.small => _smallSize,
      _SpriteSize.base => _baseSize,
      _SpriteSize.large => _largeSize,
    };

    final sprite = SpriteComponent(
      size: componentSize,
      sprite: _spritesAtlas.findSpriteByName(spriteName),
    )
      ..anchor = Anchor.center
      ..priority = 1;

    if (decorator != null) {
      sprite.decorator.addLast(decorator);
    }

    add(sprite);
  }

  /// See https://docs.flame-engine.org/1.3.0/flame/rendering/decorators.html#paintdecorator-grayscale
  @protected
  Decorator _getDisabledDecorator() => PaintDecorator.tint(AppColors.halfDark);
}