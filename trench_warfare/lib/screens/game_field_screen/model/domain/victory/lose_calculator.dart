import 'package:trench_warfare/core_entities/enums/nation.dart';
import 'package:trench_warfare/core_entities/enums/production_center_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';

class LoseCalculator {
  static bool didILose(GameFieldRead gameField, {required Nation myNation}) => !gameField.cells.any(
        (c) =>
            c.isLand &&
            c.nation == myNation &&
            (c.productionCenter?.type == ProductionCenterType.city ||
                c.productionCenter?.type == ProductionCenterType.factory),
      );
}
