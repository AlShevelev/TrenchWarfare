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

  final Set<Nation> _defeated;

  Set<Nation> get defeated => Set.unmodifiable(_defeated);

  GameOverConditionsCalculator({
    required GameFieldRead gameField,
    required MapMetadataRead metadata,
    required List<Nation> defeated,
  })  : _gameField = gameField,
        _metadata = metadata,
        _defeated = defeated.toSet();

  GameOverConditions? calculate({required Nation myNation, required Nation humanNation}) {
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

    // Defeated nations
    final defeatedNow = pcTotal.entries.where((e) => e.value == 0).map((e) => e.key).toSet();

    final allEnemies = _metadata.getEnemies(myNation);

    if (defeatedNow.contains(humanNation) || defeatedNow.containsAll(allEnemies)) {
      return GlobalVictory(nation: myNation);
    }

    // Can I use all nations except me here?
    final allOpposite = _metadata.getAllied(myNation) + _metadata.getNeutral(myNation) + allEnemies;

    final firstOppositeDefeatedNow =
        allOpposite.firstWhereOrNull((a) => defeatedNow.contains(a) && !_defeated.contains(a));

    _defeated.clear();
    _defeated.addAll(defeatedNow);

    return firstOppositeDefeatedNow?.let((e) => Defeat(nation: e));
  }

  bool isDefeated(Nation nation) => _defeated.contains(nation);
}
