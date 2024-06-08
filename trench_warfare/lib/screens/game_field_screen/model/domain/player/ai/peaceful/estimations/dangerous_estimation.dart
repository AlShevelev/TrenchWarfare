import 'package:trench_warfare/screens/game_field_screen/model/data/readers/metadata/dto/map_metadata.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/estimator.dart';
import 'package:trench_warfare/screens/game_field_screen/model/domain/player/influence_map/influence_map_library.dart';

class DangerousEstimationResult extends EstimationResult {
  DangerousEstimationResult(super.weight);
}

class DangerousEstimator implements Estimator<DangerousEstimationResult> {
  final GameFieldCellRead _cell;

  final InfluenceMapRepresentationRead _influenceMap;

  final MapMetadataRead _metadata;

  DangerousEstimator({
    required GameFieldCellRead cell,
    required InfluenceMapRepresentationRead influenceMap,
    required MapMetadataRead metadata,
  })  : _cell = cell,
        _influenceMap = influenceMap,
        _metadata = metadata;

  @override
  DangerousEstimationResult estimate() {
    final mapCell = _influenceMap.getItem(_cell.row, _cell.col);

    final allAggressive = _metadata.getAllAggressive();

    var totalDanger = 0.0;
    for (final aggressive in allAggressive) {
      totalDanger += mapCell.getCombined(aggressive);
    }

    return DangerousEstimationResult(totalDanger);
  }
}
