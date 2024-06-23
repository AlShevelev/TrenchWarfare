part of estimaitons_general;

class EqualsEstimationResult extends EstimationResult {
  EqualsEstimationResult(super.weight);
}

/// For completely random selection
class EqualsEstimator implements Estimator<EqualsEstimationResult> {

  @override
  EqualsEstimationResult estimate() => EqualsEstimationResult(1.0);
}
