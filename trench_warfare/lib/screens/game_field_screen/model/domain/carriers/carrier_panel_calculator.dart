import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/core_entities/entities/game_objects/game_object.dart';
import 'package:trench_warfare/core_entities/enums/unit_type.dart';
import 'package:trench_warfare/screens/game_field_screen/model/dto/game_field_controls/game_field_controls_library.dart';
import 'package:trench_warfare/shared/architecture/stream/streams_library.dart';

class CarrierPanelCalculator {
  static GameFieldControlsArmyInfo calculatePanel(Unit carrier, GameFieldCellRead cell) =>
      GameFieldControlsArmyInfo(
        cellId: cell.id,
        units: (carrier as Carrier).units.toList(growable: true),
      );

  static void updateCarrierPanel(
    int cellId,
    SimpleStream<GameFieldControlsState> controlsState, {
    required Unit oldActiveUnit,
    required Unit newActiveUnit,
  }) {
    if (oldActiveUnit.id == newActiveUnit.id) {
      return;
    }

    final state = (controlsState.current as MainControls);

    if (newActiveUnit.type != UnitType.carrier && state.carrierInfo != null) {
      controlsState.update(MainControls(
        money: state.money,
        cellInfo: state.cellInfo,
        armyInfo: state.armyInfo,
        carrierInfo: null,
      ));
    } else if (newActiveUnit.type == UnitType.carrier) {
      final carrier = (newActiveUnit as Carrier);

      final carrierInfo = carrier.hasUnits
          ? GameFieldControlsArmyInfo(cellId: cellId, units: carrier.units.toList(growable: true))
          : null;

      controlsState.update(MainControls(
        money: state.money,
        cellInfo: state.cellInfo,
        armyInfo: state.armyInfo,
        carrierInfo: carrierInfo,
      ));
    }
  }
}
