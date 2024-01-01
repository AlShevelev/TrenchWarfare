class Range<T extends num> {
  final T min;
  final T max;

  Range(this.min, this.max);

  bool isInRange(T value, { bool minIncluded = false }) =>
      minIncluded ? value >= min && value <= max :  value > min && value <= max;
}