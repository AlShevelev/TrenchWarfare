import 'package:trench_warfare/screens/game_field_screen/model/domain/player/estimator.dart';

class EqualsEstimationResult extends EstimationResult {
  EqualsEstimationResult(super.weight);
}

/// For completely random selection
class EqualsEstimator implements Estimator<EqualsEstimationResult> {

  @override
  EqualsEstimationResult estimate() => EqualsEstimationResult(1.0);
}
