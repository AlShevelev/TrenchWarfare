library game_field_sm;

import 'package:flutter/cupertino.dart';
import 'package:trench_warfare/core_entities/entities/game_field.dart';
import 'package:trench_warfare/core_entities/entities/game_field_cell.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/entities/money/money_unit.dart';
import 'package:trench_warfare/core_entities/enums/cell_terrain.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/production_center_level.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/core_entities/enums/special_strike_type.dart';
import 'package:trench_warfare/core_entities/enums/terrain_modifier_type.dart';
import 'package:trench_warfare/core_entities/enums/unit_boost.dart';
import 'package:trench_warfare/core_entities/enums/unit_state.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/build/build_calculators_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/common_algs/movement/movement_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/common_algs/pathfinding/path_facade.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/calculators/money_calculators_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/money/money_storage.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/update_game_event.dart';
import 'package:trench_warfare/shared/architecture/disposable.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/utils/range.dart';

part 'event.dart';
part 'state.dart';
part 'transitions/game_object_transition_base.dart';
part 'transitions/from_initial_on_init_transition.dart';
part 'transitions/from_ready_for_input_on_click.dart';
part 'transitions/from_ready_for_input_on_cards_button_click.dart';
part 'transitions/from_card_placing_on_card_placing_cancelled.dart';
part 'transitions/from_card_selecting_on_card_selected.dart';
part 'transitions/from_card_selecting_on_card_selection_cancelled.dart';
part 'transitions/from_ready_for_input_on_long_click_start.dart';
part 'transitions/from_ready_for_input_on_long_click_end.dart';
part 'transitions/from_ready_for_input_on_resort_unit.dart';
part 'transitions/from_waiting_for_end_of_path_on_click.dart';
part 'transitions/from_waiting_for_end_of_path_on_resort_unit.dart';
part 'transitions/from_path_is_shown_on_click.dart';
part 'transitions/from_path_is_shown_on_resort_unit.dart';

class GameFieldStateMachine implements Disposable {
  late final GameFieldRead _gameField;

  late final Nation _nation;

  late final MoneyStorageRead _money;

  late final MapMetadataRead _mapMetadata;

  final SingleStream<Iterable<UpdateGameEvent>> _updateGameObjectsEvent = SingleStream<Iterable<UpdateGameEvent>>();
  Stream<Iterable<UpdateGameEvent>> get updateGameObjectsEvent => _updateGameObjectsEvent.output;

  final SingleStream<GameFieldControlsState> _controlsState = SingleStream<GameFieldControlsState>();
  Stream<GameFieldControlsState> get controlsState => _controlsState.output;

  State _currentState = Initial();

  void process(Event event) {
    final newState = switch (_currentState) {
      Initial() => switch (event) {
          OnInit(
            gameField: var gameField,
            nation: var nation,
            money: var money,
            metadata: var metadata,
          ) =>
            _processInit(gameField, nation, money, metadata),
          _ => _currentState,
        },
      ReadyForInput() => switch (event) {
          OnCellClick(cell: var cell) => FromReadyForInputOnClick(
              _updateGameObjectsEvent,
              _gameField,
              _nation,
              _money.actual,
              _controlsState,
            ).process(cell),
          OnLongCellClickStart(cell: var cell) => FromReadyForInputOnLongClickStart(
              _money.actual,
              _controlsState,
            ).process(cell),
          OnLongCellClickEnd() => FromReadyForInputOnLongClickEnd(
              _money.actual,
              _controlsState,
            ).process(),
          OnUnitsResorted(cellId: var cellId, unitsId: var unitsId) => FromReadyForInputOnResortUnit(
              _updateGameObjectsEvent,
              _gameField,
            ).process(cellId, unitsId),
          OnCardsButtonClick() => FromReadyForInputOnCardsButtonClick(
              _money.actual,
              _controlsState,
              _gameField,
              _nation,
              _mapMetadata,
            ).process(),
          _ => _currentState,
        },
      WaitingForEndOfPath(startPathCell: var startPathCell) => switch (event) {
          OnCellClick(cell: var cell) => FromWaitingForEndOfPathOnClick(
              _updateGameObjectsEvent,
              _gameField,
              _money.actual,
              _controlsState,
            ).process(startPathCell, cell),
          OnUnitsResorted(cellId: var cellId, unitsId: var unitsId) => FromWaitingForEndOfPathOnResortUnit(
              _updateGameObjectsEvent,
              _gameField,
            ).process(cellId, unitsId),
          _ => _currentState,
        },
      PathIsShown(path: var path) => switch (event) {
          OnCellClick(cell: var cell) => FromPathIsShownOnClick(
              _updateGameObjectsEvent,
              _gameField,
              _nation,
              _money.actual,
              _controlsState,
            ).process(path, cell),
          OnUnitsResorted(cellId: var cellId, unitsId: var unitsId) => FromPathIsShownOnResortUnit(
              _updateGameObjectsEvent,
              _gameField,
            ).process(path, cellId, unitsId),
          _ => _currentState,
        },
      MovingInProgress() => switch (event) {
          OnMovementCompleted() => ReadyForInput(),
          _ => _currentState,
        },
      CardSelecting() => switch (event) {
        OnCardsSelectionCancelled() => FromCardSelectingOnCardsSelectionCancelled(
          _money.actual,
          _controlsState,
        ).process(),
        OnCardSelected(card: var card) => FromCardSelectingOnCardsSelected(
          _updateGameObjectsEvent,
          _gameField,
          nationMoney: _money.actual,
          nation: _nation,
          controlsState: _controlsState,
          mapMetadata: _mapMetadata,
        ).process(card),
        _ => _currentState,
      },
      CardPlacing(card: var card) => switch (event) {
        OnCardPlacingCancelled() => FromCardPlacingOnCardPlacingCancelled(
          _money.actual,
          _controlsState,
        ).process(),
        _ => _currentState,
      },
    };

    _currentState = newState;
  }

  @override
  void dispose() {
    _updateGameObjectsEvent.close();
    _controlsState.close();
  }

  State _processInit(GameFieldRead gameField, Nation nation, MoneyStorageRead money, MapMetadataRead mapMetadata) {
    _gameField = gameField;
    _nation = nation;
    _money = money;
    _mapMetadata = mapMetadata;

    return FromInitialOnInitTransition(
      _updateGameObjectsEvent,
      _gameField,
      _controlsState,
      _money.actual,
    ).process();
  }
}
