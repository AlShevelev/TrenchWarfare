import 'package:collection/collection.dart';
import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/victory/victory_type.dart';
import 'package:trench_warfare/shared/helpers/extensions.dart';

class VictoryCalculator {
  final GameFieldRead _gameField;

  final MapMetadataRead _metadata;

  final Nation _myNation;

  final defeated = <Nation>{};

  VictoryCalculator({
    required GameFieldRead gameField,
    required MapMetadataRead metadata,
    required Nation myNation,
  })  : _gameField = gameField,
        _metadata = metadata,
        _myNation = myNation;

  VictoryType? calculateVictory() {
    final pcTotal = <Nation, int>{};
    pcTotal.addEntries(
      _metadata.getAll().where((it) => it != _myNation).map((it) => MapEntry(it, 0)),
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

    final allEnemies = _metadata.getMyEnemies(_myNation);

    if (defeatedNow.containsAll(allEnemies)) {
      return GlobalVictory(nation: _myNation);
    }

    final allNotEnemies = _metadata.getMyNotEnemies(_myNation);

    final firstNotEnemyDefeatedNow =
        allNotEnemies.firstWhereOrNull((a) => defeatedNow.contains(a) && !defeated.contains(a));

    defeated.clear();
    defeated.addAll(defeatedNow);

    return firstNotEnemyDefeatedNow?.let((e) => Defeat(nation: e));
  }

  bool isDefeated(Nation nation) => defeated.contains(nation);
}
