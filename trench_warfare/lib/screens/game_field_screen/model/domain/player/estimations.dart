abstract class EstimationResult {
  final double weight;

  EstimationResult(this.weight);
}

abstract interface class Estimator<T extends EstimationResult> {
  T estimate();
}

abstract class EstimationRecord<T, R extends EstimationResult> {
  final T type;

  final R result;

  EstimationRecord({required this.type, required this.result});
}
