class EstimationResult<D> {
  final double weight;

  final D data;

  EstimationResult({required this.weight, required this.data});
}

abstract interface class Estimator<D> {
  Iterable<EstimationResult<D>> estimate();
}
