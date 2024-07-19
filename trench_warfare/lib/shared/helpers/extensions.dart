import 'package:collection/collection.dart';

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
  double average() => sum / length;
}

extension ListsGeneral<T> on Iterable<T> {
  int count(bool Function(T) condition) {
    var counter = 0;

    for (final item in this) {
      if (condition(item)) {
        counter++;
      }
    }

    return counter;
  }

  bool all(bool Function(T) condition) {
    var counter = 0;

    for (final item in this) {
      if (condition(item)) {
        counter++;
      }
    }

    return counter == length;
  }
}
