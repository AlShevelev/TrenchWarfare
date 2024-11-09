import 'package:trench_warfare/app/navigation/navigation_library.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/screens/new_game/model/dto/map_selection_dto_library.dart';
import 'package:trench_warfare/screens/new_game/model/maps_data_loader.dart';
import 'package:trench_warfare/screens/new_game/view_model/map_selection_user_actions.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';

class MapSelectionViewModel extends ViewModelBase implements MapSelectionUserActions {
  final SingleStream<MapSelectionState> _gameFieldState = SingleStream<MapSelectionState>();
  Stream<MapSelectionState> get gameFieldState => _gameFieldState.output;

  MapSelectionViewModel() {
    _gameFieldState.update(Loading());
  }

  Future<void> init() async {
    final dataLoader = MapsDataLoader();

    _gameFieldState.update(DataIsReady(
      tabs: [
        await _loadTab(
          dataLoader,
          'tiles/real/europe',
          TabCode.europe,
          selected: true,
        ),
        await _loadTab(
          dataLoader,
          'tiles/real/asia',
          TabCode.asia,
        ),
        await _loadTab(
          dataLoader,
          'tiles/real/new_world',
          TabCode.newWorld,
        ),
      ],
    ));
  }

  @override
  void dispose() {
    _gameFieldState.close();
  }

  Future<MapTabDto> _loadTab(
    MapsDataLoader dataLoader,
    String filter,
    TabCode tabCode, {
    bool selected = false,
  }) async {
    try {
      return dataLoader.loadTab(
        filter,
        tabCode,
        selected: selected,
      );
    } catch (e, s) {
      Logger.error(e.toString(), stackTrace: s);
      return MapTabDto(code: tabCode, selected: selected, cards: []);
    }
  }

  @override
  void onCardSelected(String cardId) => _updateState((oldState) {
        final selectedTab = oldState.selectedTab;

        for (var card in selectedTab.cards) {
          card.setSelected(card.id == cardId);
        }
      });

  @override
  void onOpponentSelected(String cardId, Nation opponentNation) => _updateState((oldState) =>
      oldState.selectedTab.cards.singleWhere((c) => c.id == cardId).setSelectedOpponent(opponentNation));

  @override
  void onTabSelected(TabCode tabCode) => _updateState((oldState) {
        for (var tab in oldState.tabs) {
          tab.setSelected(tab.code == tabCode);
        }
      });

  NewGameToGameFieldNavArg? getNavigateToGameFieldArguments() {
    final state = _gameFieldState.current;

    if (state is DataIsReady) {
      final selectedCard = state.selectedTab.cards.singleWhere((c) => c.selected);
      return NewGameToGameFieldNavArg(
        mapName: selectedCard.mapFileName,
        selectedNation: selectedCard.opponents.firstWhere((o) => o.selected).nation,
      );
    }

    return null;
  }

  void _updateState(void Function(DataIsReady) action) {
    final state = _gameFieldState.current;

    if (state is DataIsReady) {
      action(state);

      final newState = state.copy(state.tabs);
      _gameFieldState.update(newState);
    }
  }
}
