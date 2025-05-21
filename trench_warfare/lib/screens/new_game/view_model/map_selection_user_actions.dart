import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/screens/new_game/model/dto/map_selection_dto_library.dart';

abstract interface class MapSelectionUserActions {
  void onTabSelected(TabCode tabCode);

  void onCardSelected(String cardId);

  void onCardExpanded(String cardId);

  void onOpponentSelected(String cardId, Nation opponent);
}