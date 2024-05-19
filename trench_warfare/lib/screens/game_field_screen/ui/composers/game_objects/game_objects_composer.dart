import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/game_field_components_library.dart';
import 'package:trench_warfare/shared/utils/range.dart';
import 'package:tuple/tuple.dart';

typedef OnAnimationCompletedCallback = void Function();

class GameObjectsComposer {
  late final GameFieldRead _gameField;

  late final TextureAtlas _spritesAtlas;
  late final Image _animationAtlas;

  late final TiledComponent _mapComponent;

  final Map<String, PositionComponent> _gameObjects = {};

  late final OnAnimationCompletedCallback _onAnimationCompletedCallback;

  GameObjectsComposer(
    TiledComponent mapComponent,
    TextureAtlas spritesAtlas, {
    required Image animationAtlas,
  }) {
    _spritesAtlas = spritesAtlas;
    _animationAtlas = animationAtlas;

    _mapComponent = mapComponent;
  }

  void init(GameFieldRead gameField, OnAnimationCompletedCallback onAnimationCompletedCallback) {
    _gameField = gameField;
    _onAnimationCompletedCallback = onAnimationCompletedCallback;
  }

  Future<void> onUpdateGameEvent(UpdateGameEvent event) async {
    switch (event) {
      case UpdateCell(cell: var cell, updateBorderCells: var updateBorderCells):
        _updateCell(cell, updateBorderCells);

      case UpdateCellInactivity(
          oldInactiveCells: var oldInactiveCells,
          newInactiveCells: var newInactiveCells
        ):
        _updateCellInactivity(oldInactiveCells, newInactiveCells);

      case CreateUntiedUnit(cell: var cell, unit: var unit):
        _createUntiedUnit(cell, unit);

      case RemoveUntiedUnit(unit: var unit):
        _removeUntiedUnit(unit);

      case MoveUntiedUnit(startCell: var startCell, endCell: var endCell, unit: var unit, time: var time):
        await _moveUntiedUnit(startCell, endCell, unit, time);

      case Pause(time: var time):
        await _pause(time);

      case ShowDamage(cell: var cell, damageType: var damageType, time: var time):
        await _showDamage(cell, damageType, time);

      case ShowComplexDamage(
          cells: var cells,
          time: var time,
        ):
        await _showComplexDamage(cells, time);

      case AnimationCompleted():
        _onAnimationCompletedCallback();

      default: {}
    }
  }

  void _updateCell(GameFieldCell cell, Iterable<GameFieldCell> updateBorderCells) {
    final borderComponentKey = _getBorderComponentKey(cell);

    _removeGameObject(_getCellComponentKey(cell));
    _removeGameObject(borderComponentKey);

    _addGameObject(GameCellBorder(cell, _gameField), borderComponentKey);
    _addGameObject(GameObjectCell(_spritesAtlas, cell), _getCellComponentKey(cell));

    for (var updateBorderCell in updateBorderCells) {
      final updateBorderComponentKey = _getBorderComponentKey(updateBorderCell);
      _removeGameObject(updateBorderComponentKey);
      _addGameObject(GameCellBorder(updateBorderCell, _gameField), updateBorderComponentKey);
    }
  }

  void _updateCellInactivity(
      Map<int, GameFieldCellRead> oldInactiveCells, Map<int, GameFieldCellRead> newInactiveCells) {
    for (var o in oldInactiveCells.entries) {
      if (!newInactiveCells.containsKey(o.key)) {
        _removeGameObject(_getInactivityComponentKey(o.value));
      }
    }

    for (var n in newInactiveCells.entries) {
      if (!oldInactiveCells.containsKey(n.key)) {
        _addGameObject(GameCellInactive(n.value), _getInactivityComponentKey(n.value));
      }
    }
  }

  void _createUntiedUnit(GameFieldCell cell, Unit unit) {
    final gameObject = GameObjectUntiedUnit(
      spritesAtlas: _spritesAtlas,
      position: cell.center,
      unit: unit,
      nation: cell.nation!,
    );

    _addGameObject(gameObject, unit.id);
  }

  void _removeUntiedUnit(Unit unit) {
    _removeGameObject(unit.id);
  }

  Future<void> _moveUntiedUnit(GameFieldCell startCell, GameFieldCell endCell, Unit unit, int time) async {
    final unitSprite = _gameObjects[unit.id];

    if (unitSprite == null) {
      return;
    }

    final effect = MoveToEffect(endCell.center, EffectController(duration: _millisecondsToSeconds(time)));
    unitSprite.add(effect);

    await Future.delayed(Duration(milliseconds: time));
  }

  Future<void> _pause(int time) async {
    await Future.delayed(Duration(milliseconds: time));
  }

  Future<void> _showDamage(GameFieldCell cell, DamageType damageType, int time) async {
    _showAnimation(cell: cell, time: time, atlas: _animationAtlas, frames: _getAnimationFrames(damageType));
    await Future.delayed(Duration(milliseconds: time));
  }

  Future<void> _showComplexDamage(
    Iterable<Tuple2<GameFieldCellRead, DamageType>> cells,
    int time,
  ) async {
    for (var cell in cells) {
      _showAnimation(
          cell: cell.item1,
          time: time,
          atlas: _animationAtlas,
          frames: _getAnimationFrames(
            cell.item2,
          ));
    }
    await Future.delayed(Duration(milliseconds: time));
  }

  void _addGameObject(PositionComponent gameObject, String id) {
    _mapComponent.add(gameObject);
    _gameObjects[id] = gameObject;
  }

  void _removeGameObject(String id) {
    final gameObject = _gameObjects.remove(id);

    if (gameObject != null) {
      _mapComponent.remove(gameObject);
    }
  }

  double _millisecondsToSeconds(int time) => 1 / 1000 * time;

  void _showAnimation({
    required GameFieldCellRead cell,
    required int time,
    required Image atlas,
    required Range<int> frames,
  }) {
    final totalTimeInSeconds = _millisecondsToSeconds(time);

    final animationComponent = AnimationFrameToFrameComponent(
      animationAtlas: atlas,
      totalTimeInSeconds: totalTimeInSeconds,
      frames: frames,
      position: cell.center,
    );

    animationComponent.add(RemoveEffect(delay: totalTimeInSeconds));

    _mapComponent.add(animationComponent);
  }

  Range<int> _getAnimationFrames(DamageType damageType) => switch (damageType) {
        DamageType.bloodSplash => Range(0, 12),
        DamageType.explosion => Range(13, 20),
        DamageType.flame => Range(21, 29),
        DamageType.gasAttack => Range(30, 37),
        DamageType.propaganda => Range(38, 46),
      };

  String _getCellComponentKey(GameFieldCell cell) => '${cell.id}_cell';

  String _getBorderComponentKey(GameFieldCell cell) => '${cell.id}_border';

  String _getInactivityComponentKey(GameFieldCellRead cell) => '${cell.id}_inactive';
}
