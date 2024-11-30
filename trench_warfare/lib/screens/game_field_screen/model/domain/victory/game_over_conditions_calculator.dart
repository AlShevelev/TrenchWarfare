import 'package:collection/collection.dart';
import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/enums/production_center_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/victory/game_over_conditions.dart';
import 'package:trench_warfare/shared/helpers/extensions.dart';

class GameOverConditionsCalculator {
  final GameFieldRead _gameField;

  final MapMetadataRead _metadata;

  final defeated = <Nation>{};

  GameOverConditionsCalculator({
    required GameFieldRead gameField,
    required MapMetadataRead metadata,
  })  : _gameField = gameField,
        _metadata = metadata;

  GameOverConditions? calculate(Nation nation) {
    if (_gameField.cells.isEmpty) {
      return null;
    }

    final pcTotal = <Nation, int>{};
    pcTotal.addEntries(
      _metadata.getAll().map((it) => MapEntry(it, 0)),
    );

    for (final cell in _gameField.cells) {
      if (!cell.isLand ||
          cell.nation == null ||
          cell.productionCenter == null ||
          cell.productionCenter?.type == ProductionCenterType.airField) {
        continue;
      }

      pcTotal[cell.nation!] = (pcTotal[cell.nation!] ?? 0) + 1;
    }

    final defeatedNow = pcTotal.entries.where((e) => e.value == 0).map((e) => e.key).toSet();

    final allEnemies = _metadata.getMyEnemies(nation);

    if (defeatedNow.containsAll(allEnemies)) {
      return GlobalVictory(nation: nation);
    }

    final allOpposite = _metadata.getMyNotEnemies(nation) + allEnemies;

    final firstOppositeDefeatedNow =
        allOpposite.firstWhereOrNull((a) => defeatedNow.contains(a) && !defeated.contains(a));

    defeated.clear();
    defeated.addAll(defeatedNow);

    return firstOppositeDefeatedNow?.let((e) => Defeat(nation: e));
  }

  bool isDefeated(Nation nation) => defeated.contains(nation);
}
