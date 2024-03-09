import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_gdx_texture_packer/atlas/texture_atlas.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/screens/game_field_screen/model/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/ui/game_object_components/game_field_components_library.dart';
import 'package:trench_warfare/shared/architecture/disposable.dart';

class GameObjectsComposer implements Disposable {
  late final GameFieldRead _gameField;

  late final TextureAtlas _spritesAtlas;
  late final Image _explosionAnimationAtlas;
  late final Image _bloodSplashesAnimationAtlas;

  StreamSubscription? _updateGameObjectsSubscription;

  late final TiledComponent _mapComponent;

  final Map<String, PositionComponent> _gameObjects = {};

  late final void Function() _onMoveCompletedCallback;

  GameObjectsComposer(
    TiledComponent mapComponent,
    Stream<Iterable<UpdateGameEvent>> updateGameObjectScream,
    TextureAtlas spritesAtlas,
    void Function() onMoveCompletedCallback, {
    required Image explosionAnimationAtlas,
    required Image bloodSplashesAnimationAtlas,
  }) {
    _spritesAtlas = spritesAtlas;
    _explosionAnimationAtlas = explosionAnimationAtlas;
    _bloodSplashesAnimationAtlas = bloodSplashesAnimationAtlas;

    _updateGameObjectsSubscription = updateGameObjectScream.listen(_onUpdateGameEvent);
    _mapComponent = mapComponent;

    _onMoveCompletedCallback = onMoveCompletedCallback;
  }

  void init(GameFieldRead gameField) {
    _gameField = gameField;
  }

  @override
  void dispose() {
    _updateGameObjectsSubscription?.cancel();
  }

  void _onUpdateGameEvent(Iterable<UpdateGameEvent> events) async {
    for (var event in events) {
      switch (event) {
        case UpdateObject(cell: var cell):
          _updateCell(cell);

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

        case ShowDualDamage(
            cell1: var cell1,
            damageType1: var damageType1,
            cell2: var cell2,
            damageType2: var damageType2,
            time: var time,
          ):
          await _showDualDamage(cell1, damageType1, cell2, damageType2, time);

        case MovementCompleted():
          _onMoveCompletedCallback();
      }
    }
  }

  void _updateCell(GameFieldCell cell) {
    final borderComponentKey = '${cell.id}_border';

    _removeGameObject(cell.id);
    _removeGameObject(borderComponentKey);

    _addGameObject(GameCellBorder(cell, _gameField), borderComponentKey);
    _addGameObject(GameObjectCell(_spritesAtlas, cell), cell.id);
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
    _showAnimation(cell: cell, time: time, atlas: _getAnimationAtlas(damageType), frames: _getAnimationFrames(damageType));
    await Future.delayed(Duration(milliseconds: time));
  }

  Future<void> _showDualDamage(
    GameFieldCell cell1,
    DamageType damageType1,
    GameFieldCell cell2,
    DamageType damageType2,
    int time,
  ) async {
    _showAnimation(cell: cell1, time: time, atlas: _getAnimationAtlas(damageType1), frames: _getAnimationFrames(damageType1));
    _showAnimation(cell: cell2, time: time, atlas: _getAnimationAtlas(damageType2), frames: _getAnimationFrames(damageType2));
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
    required GameFieldCell cell,
    required int time,
    required Image atlas,
    required int frames,
  }) {
    final timeInSeconds = _millisecondsToSeconds(time);

    final animationComponent = AnimationFrameToFrameComponent(
      animationAtlas: atlas,
      stepTime: timeInSeconds / frames,
      position: cell.center,
    );

    animationComponent.add(RemoveEffect(delay: timeInSeconds));

    _mapComponent.add(animationComponent);
  }

  Image _getAnimationAtlas(DamageType damageType) => switch (damageType) {
        DamageType.explosion => _explosionAnimationAtlas,
        DamageType.bloodSplash => _bloodSplashesAnimationAtlas,
      };

  int _getAnimationFrames(DamageType damageType) => switch (damageType) {
        DamageType.explosion => 8,
        DamageType.bloodSplash => 13,
      };
}
