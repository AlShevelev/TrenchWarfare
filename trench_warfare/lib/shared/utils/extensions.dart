/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

import 'package:collection/collection.dart';

extension ComponMethods<T> on T {
  R? let<R>(R Function(T) action) {
    if (this == null) {
      return null;
    }

    return action(this);
  }
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
