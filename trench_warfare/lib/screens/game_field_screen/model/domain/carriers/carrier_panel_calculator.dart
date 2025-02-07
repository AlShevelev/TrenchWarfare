import 'package:trench_warfare/core/enums/nation.dart';
import 'package:trench_warfare/core/entities/game_field/game_field_library.dart';
import 'package:trench_warfare/core/entities/game_objects/game_object_library.dart';
import 'package:trench_warfare/core/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';

class CarrierPanelCalculator {
  static GameFieldControlsArmyInfo calculatePanel(Unit carrier, GameFieldCellRead cell) =>
      GameFieldControlsArmyInfo(
        cellId: cell.id,
        nation: cell.nation!,
        units: (carrier as Carrier).units.toList(growable: true),
      );

  static void updateCarrierPanel(
    int cellId,
    Nation nation,
    SimpleStream<GameFieldControlsState> controlsState, {
    required Unit oldActiveUnit,
    required Unit newActiveUnit,
  }) {
    if (oldActiveUnit.id == newActiveUnit.id) {
      return;
    }

    final state = (controlsState.current as MainControls);

    if (newActiveUnit.type != UnitType.carrier && state.carrierInfo != null) {
      controlsState.update(state.setCarrierInfo(null));
    } else if (newActiveUnit.type == UnitType.carrier) {
      final carrier = (newActiveUnit as Carrier);

      final carrierInfo = carrier.hasUnits
          ? GameFieldControlsArmyInfo(
              cellId: cellId,
              nation: nation,
              units: carrier.units.toList(growable: true),

            )
          : null;

      controlsState.update(state.setCarrierInfo(carrierInfo));
    }
  }
}
