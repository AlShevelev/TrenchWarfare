import 'package:test/test.dart';
import 'package:trench_warfare/shared/utils/random_gen.dart';

import 'assert.dart';

void main() {
  group('HexMatrix normal cases', () {
    test('weights are empty', () {
      // Arrange
      final List<double> weights = [];
      var hasError = false;

      // Act
      final result = RandomGen.randomWeight(weights);

      // Assert
      Assert.isNull(result);
    });

    test('weights has one item only', () {
      // Arrange
      final List<double> weights = [42];

      // Act
      final result = RandomGen.randomWeight(weights);

      // Assert
      Assert.equals(result, 0);
    });

    test('weights are all zeros', () {
      // Arrange
      final List<double> weights = [0, 0, 0];

      // Act
      final result = RandomGen.randomWeight(weights);

      // Assert
      Assert.isNull(result);
    });

    test('weights list has a negative item', () {
      // Arrange
      final List<double> weights = [0, -42.0, 0];

      // Act
      final result = RandomGen.randomWeight(weights);

      // Assert
      Assert.isNull(result);
    });

    test('weights have two equals values', () {
      // Arrange
      final List<double> weights = [13, 13];
      final accumulate = [0, 0];

      // Act
      for (var i = 0; i < 10000000; i++) {
        final result = RandomGen.randomWeight(weights);
        accumulate[result!] = accumulate[result] + 1;
      }

      // Assert
      Assert.equalsDouble(
        actual: accumulate[0].toDouble(),
        expected: accumulate[1].toDouble(),
        precision: 0.01,
      );
    });

    test('weights have two non-equals values', () {
      // Arrange
      final List<double> weights = [1, 10];
      final accumulate = [0, 0];

      // Act
      for (var i = 0; i < 10000000; i++) {
        final result = RandomGen.randomWeight(weights);
        accumulate[result!] = accumulate[result] + 1;
      }

      // Assert
      Assert.equalsDouble(
        actual: accumulate[1].toDouble() / accumulate[0].toDouble(),
        expected: 10.0,
        precision: 0.01,
      );
    });

    test('weights start with zero value', () {
      // Arrange
      final List<double> weights = [0, 10];
      final accumulate = [0, 0];

      // Act
      for (var i = 0; i < 10000000; i++) {
        final result = RandomGen.randomWeight(weights);
        accumulate[result!] = accumulate[result] + 1;
      }

      // Assert
      Assert.equals(accumulate[0], 0);
      Assert.equals(accumulate[1], 10000000);
    });

    test('weights end with zero value', () {
      // Arrange
      final List<double> weights = [10, 0];
      final accumulate = [0, 0];

      // Act
      for (var i = 0; i < 10000000; i++) {
        final result = RandomGen.randomWeight(weights);
        accumulate[result!] = accumulate[result] + 1;
      }

      // Assert
      Assert.equals(accumulate[0], 10000000);
      Assert.equals(accumulate[1], 0);
    });

    test('weights start and end with zero values', () {
      // Arrange
      final List<double> weights = [0, 10, 0];
      final accumulate = [0, 0, 0];

      // Act
      for (var i = 0; i < 10000000; i++) {
        final result = RandomGen.randomWeight(weights);
        accumulate[result!] = accumulate[result] + 1;
      }

      // Assert
      Assert.equals(accumulate[0], 0);
      Assert.equals(accumulate[1], 10000000);
      Assert.equals(accumulate[2], 0);
    });
  });
}
