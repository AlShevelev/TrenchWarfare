/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

class Range<T extends num> {
  final T min;
  final T max;

  Range(this.min, this.max);

  bool isInRange(T value, { bool minIncluded = false }) =>
      minIncluded ? value >= min && value <= max :  value > min && value <= max;
}