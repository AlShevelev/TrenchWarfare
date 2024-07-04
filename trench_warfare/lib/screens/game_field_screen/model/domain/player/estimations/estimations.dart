abstract interface class EstimationData {}

class EstimationResult<D extends EstimationData> {
  final double weight;

  final D data;

  EstimationResult({required this.weight, required this.data});
}

abstract interface class Estimator<D extends EstimationData> {
  Iterable<EstimationResult<D>> estimate();
}
