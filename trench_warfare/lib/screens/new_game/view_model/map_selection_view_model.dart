import 'package:trench_warfare/screens/new_game/model/dto/map_selection_dto_library.dart';
import 'package:trench_warfare/screens/new_game/model/maps_data_loader.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';
import 'package:trench_warfare/shared/architecture/view_model_base.dart';
import 'package:trench_warfare/shared/logger/logger_library.dart';

class MapSelectionViewModel extends ViewModelBase {
  final SingleStream<MapSelectionState> _gameFieldState = SingleStream<MapSelectionState>();
  Stream<MapSelectionState> get gameFieldState => _gameFieldState.output;

  MapSelectionViewModel() {
    _gameFieldState.update(Loading());
  }

  Future<void> init() async {
    final dataLoader = MapsDataLoader();

    _gameFieldState.update(DataIsReady(
      tabs: {
        TabCode.europe: await _loadTab(
          dataLoader,
          'tiles/real/europe',
          TabCode.europe,
          selected: true,
        ),
        TabCode.asia: await _loadTab(
          dataLoader,
          'tiles/real/asia',
          TabCode.asia,
        ),
        TabCode.newWorld: await _loadTab(
          dataLoader,
          'tiles/real/new_world',
          TabCode.newWorld,
        ),
      },
    ));
  }

  @override
  void dispose() {
    _gameFieldState.close();
  }

  Future<Tab> _loadTab(
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
      return Tab(code: tabCode, selected: selected, cards: []);
    }
  }
}
