import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/localization/app_locale.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/game_field_components_library.dart';
import 'package:trench_warfare/screens/game_field_screen/view_model/game_field_view_model.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';
import 'package:trench_warfare/shared/utils/range.dart';
import 'package:tuple/tuple.dart';

typedef OnAnimationCompletedCallback = void Function();

class GameObjectsComposer {
  late final GameFieldRead _gameField;

  final TextureAtlas _spritesAtlas;
  final Image _animationAtlas;

  final TiledComponent _mapComponent;

  final Map<String, PositionComponent> _gameObjects = {};

  late final GameFieldViewModelInput _viewModelInput;

  final AppLocale _locale;

  GameObjectsComposer(
    TiledComponent mapComponent,
    TextureAtlas spritesAtlas,
    AppLocale locale, {
    required Image animationAtlas,
  })  : _spritesAtlas = spritesAtlas,
        _animationAtlas = animationAtlas,
        _mapComponent = mapComponent,
        _locale = locale;

  void init(GameFieldRead gameField, GameFieldViewModelInput viewModelInput) {
    _gameField = gameField;
    _viewModelInput = viewModelInput;
  }

  Future<void> onUpdateGameEvent(UpdateGameEvent event) async {
    Logger.debug('Root game objects total: ${_mapComponent.children.length}', tag: 'GAME_OBJ_TOTAL');

    switch (event) {
      case UpdateCell(cell: var cell, updateBorderCells: var updateBorderCells):
        await _updateCell(cell, updateBorderCells);

      case UpdateCellInactivity(
          oldInactiveCells: var oldInactiveCells,
          newInactiveCells: var newInactiveCells
        ):
        await _updateCellInactivity(oldInactiveCells, newInactiveCells);

      case CreateUntiedUnit(cell: var cell, unit: var unit):
        await _createUntiedUnit(cell, unit);

      case RemoveUntiedUnit(unit: var unit):
        _removeUntiedUnit(unit);

      case MoveUntiedUnit(startCell: var startCell, endCell: var endCell, unit: var unit, time: var time):
        await _moveUntiedUnit(startCell, endCell, unit, time);

      case Pause(time: var time):
        await _pause(time);

      case ShowDamage(
          cell: var cell,
          damageType: var damageType,
          time: var time,
        ):
        await _showDamage(cell, damageType, time);

      case ShowComplexDamage(
          cells: var cells,
          time: var time,
        ):
        await _showComplexDamage(cells, time);

      case AnimationCompleted():
        _viewModelInput.gameObjectCallback.onAnimationComplete();

      default:
        {}
    }
  }

  Future<void> _updateCell(GameFieldCellRead cell, Iterable<GameFieldCellRead> updateBorderCells) async {
    _removeGameObject(_getCellComponentKey(cell));

    for (var updateBorderCell in updateBorderCells) {
      _removeGameObject(_getCellComponentKey(updateBorderCell));

      if (GameObjectCell.needToDrawCell(updateBorderCell, _gameField)) {
        await _addGameObject(
            GameObjectCell(
              _spritesAtlas,
              updateBorderCell,
              _viewModelInput.isHumanPlayer,
              _gameField,
              _locale,
            ),
            _getCellComponentKey(updateBorderCell));
      }
    }

    if (GameObjectCell.needToDrawCell(cell, _gameField)) {
      await _addGameObject(
          GameObjectCell(
            _spritesAtlas,
            cell,
            _viewModelInput.isHumanPlayer,
            _gameField,
            _locale,
          ),
          _getCellComponentKey(cell));
    }
  }

  Future<void> _updateCellInactivity(
      Map<int, GameFieldCellRead> oldInactiveCells, Map<int, GameFieldCellRead> newInactiveCells) async {
    for (var o in oldInactiveCells.entries) {
      if (!newInactiveCells.containsKey(o.key)) {
        _removeGameObject(_getInactivityComponentKey(o.value));
      }
    }

    for (var n in newInactiveCells.entries) {
      if (!oldInactiveCells.containsKey(n.key)) {
        await _addGameObject(GameCellInactive(n.value), _getInactivityComponentKey(n.value));
      }
    }
  }

  Future<void> _createUntiedUnit(GameFieldCellRead cell, Unit unit) async {
    final gameObject = GameObjectUntiedUnit(
      spritesAtlas: _spritesAtlas,
      position: cell.center,
      unit: unit,
      nation: cell.nation!,
      isHuman: _viewModelInput.isHumanPlayer,
    );

    await _addGameObject(gameObject, unit.id);
  }

  void _removeUntiedUnit(Unit unit) {
    _removeGameObject(unit.id);
  }

  Future<void> _moveUntiedUnit(
    GameFieldCellRead startCell,
    GameFieldCellRead endCell,
    Unit unit,
    int time,
  ) async {
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

  Future<void> _showDamage(
    GameFieldCellRead cell,
    DamageType damageType,
    int time,
  ) async {
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

  Future<void> _addGameObject(PositionComponent gameObject, String id) async {
    await _mapComponent.add(gameObject);
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

  String _getCellComponentKey(GameFieldCellRead cell) => '${cell.id}_cell';

  String _getInactivityComponentKey(GameFieldCellRead cell) => '${cell.id}_inactive';
}
