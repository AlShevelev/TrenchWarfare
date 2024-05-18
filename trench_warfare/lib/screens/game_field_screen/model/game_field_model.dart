import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/foundation.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/game_field/game_field_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/metadata_reader.dart';
import 'package:trench_warfare/screens/game_field_screen/model/game_field_storage/game_field_settings_storage.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/money_storage.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/sm/game_field_sm_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/shared/architecture/disposable.dart';
import 'package:tuple/tuple.dart';

class GameFieldModel implements Disposable {
  late final MapMetadata _metadata;

  late final GameFieldRead _gameField;
  GameFieldRead get gameField => _gameField;

  late final GameFieldStateMachine _stateMachine = GameFieldStateMachine();

  Stream<GameFieldControlsState> get controlsState => _stateMachine.controlsState;

  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _stateMachine.updateGameObjectsEvent;

  NationRecord get _playerNation => _metadata.nations.first;

  late final MoneyStorage _money;

  final GameFieldSettingsStorage _gameFieldSettingsStorage = GameFieldSettingsStorage();

  GameFieldModel();

  Future<void> init(RenderableTiledMap tileMap) async {
    _metadata = await compute(MetadataReader.read, tileMap.map);
    _gameField = await compute(
      GameFieldReader.read,
      Tuple2<Vector2, TiledMap>(tileMap.destTileSize, tileMap.map),
    );

    _money = MoneyStorage(_gameField, _playerNation);

    _stateMachine.process(OnInit(
      _gameField,
      _playerNation.code,
      _money,
      _metadata,
      _gameFieldSettingsStorage,
    ));
  }

  void onClick(Vector2 position) {
    final clickedCell = _gameField.findCellByPosition(position);
    _stateMachine.process(OnCellClick(clickedCell));
  }

  void onLongClickStart(Vector2 position) {
    final clickedCell = _gameField.findCellByPosition(position);
    _stateMachine.process(OnLongCellClickStart(clickedCell));
  }

  void onLongClickEnd() {
    _stateMachine.process(OnLongCellClickEnd());
  }

  void onAnimationComplete() => _stateMachine.process(OnAnimationCompleted());

  void onResortUnits(int cellId, Iterable<String> unitsId, {required bool isCarrier}) =>
      _stateMachine.process(OnUnitsResorted(cellId, unitsId, isCarrier: isCarrier));

  void onCardsButtonClick() => _stateMachine.process(OnCardsButtonClick());

  void onEndOfTurnButtonClick() => _stateMachine.process(OnEndOfTurnButtonClick());

  void onCardsSelectionCancelled() => _stateMachine.process(OnCancelled());

  void onCardSelected(GameFieldControlsCard? card) {
    if (card == null) {
      _stateMachine.process(OnCancelled());
    } else {
      _stateMachine.process(OnCardSelected(card));
    }
  }

  void onCardsPlacingCancelled() => _stateMachine.process(OnCancelled());

  void onCameraUpdated(double zoom, Vector2 position) {
    _gameFieldSettingsStorage.zoom = zoom;
    _gameFieldSettingsStorage.cameraPosition = position;
  }

  @override
  void dispose() {
    _stateMachine.dispose();
  }
}
