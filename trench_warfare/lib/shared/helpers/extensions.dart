extension ComponMethods<T> on T {
  R? let<R>(R Function(T) action) {
    if (this == null) {
      return null;
    }

    return action(this);
  }
}

extension ListsInt on Iterable<int> {
  int sum() => fold(0, (p, c) => p + c);
}

extension ListsDouble on Iterable<double> {
  double sum() => fold(0.0, (p, c) => p + c);
}
