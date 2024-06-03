import 'dart:math' as math;

import 'package:test/test.dart';

class Assert {
  static void isTrue(bool value) {
    expect(value, true);
  }

  static void isFalse(bool value) {
    expect(value, false);
  }

  static void isNull<T>(T? value) {
    expect(value == null, true);
  }

  static void isNotNull<T>(T? value) {
    expect(value != null, true);
  }

  static void equals<T>(T actual, T expected) {
    expect(actual, expected);
  }

  static void equalsDouble(double actual, double expected) {
    isTrue((actual - expected).abs() < 0.0001);
  }
}