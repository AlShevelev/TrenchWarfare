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

    final europeTab = await _loadTab(dataLoader, 'tiles/real/europe');
    final asiaTab = await _loadTab(dataLoader, 'tiles/real/asia');
    final newWorldTab = await _loadTab(dataLoader, 'tiles/real/new_world');

    _gameFieldState.update(DataIsReady(
      europeTab: europeTab.copy(selected: true),
      asiaTab: asiaTab,
      newWorldTab: newWorldTab,
    ));
  }

  @override
  void dispose() {
    _gameFieldState.close();
  }

  Future<Tab> _loadTab(MapsDataLoader dataLoader, String filter) async {
    try {
      return dataLoader.loadTab(filter);
    } catch (e, s) {
      Logger.error(e.toString(), stackTrace: s);
      return Tab(selected: false, cards: []);
    }
  }
}
