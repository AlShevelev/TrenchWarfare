abstract class EstimationResult {
  final double weight;

  EstimationResult(this.weight);
}
abstract interface class Estimator<T extends EstimationResult> {
  T estimate();
}