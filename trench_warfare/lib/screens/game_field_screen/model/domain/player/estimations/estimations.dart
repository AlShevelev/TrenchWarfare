import 'package:trench_warfare/screens/game_field_screen/model/domain/game_field/game_field_library.dart';

abstract interface class EstimationData {
  GameFieldCellRead get cell;
}

class EstimationResult<D extends EstimationData> {
  final double weight;

  final D data;

  EstimationResult({required this.weight, required this.data});
}

abstract interface class Estimator<D extends EstimationData> {
  Iterable<EstimationResult<D>> estimate();
}
