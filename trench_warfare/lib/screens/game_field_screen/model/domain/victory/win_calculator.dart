import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';

class WinCalculator {
  static bool didIWin(GameFieldRead gameField, MapMetadataRead metadata, {required Nation myNation}) {
    final allEnemies = metadata.getMyEnemies(myNation);

    return !gameField.cells.any(
      (c) =>
          c.isLand &&
          (c.productionCenter?.type == ProductionCenterType.city ||
              c.productionCenter?.type == ProductionCenterType.factory) &&
          allEnemies.contains(c.nation),
    );
  }
}
