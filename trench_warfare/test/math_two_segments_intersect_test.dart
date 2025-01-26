import 'package:flame/components.dart';
import 'package:test/test.dart';
import 'package:trench_warfare/shared/utils/math.dart';

import 'assert.dart';

void main() {
  group('math - TwoSegmentsIntersect', () {
    test('cross', () {
      // Arrange
      final start1 = Vector2(1, 1);
      final end1 = Vector2(10, 10);

      final start2 = Vector2(1, 10);
      final end2 = Vector2(10, 1);

      // Act
      final result = InGameMath.doTwoSegmentsIntersect(start1: start1, end1: end1, start2: start2, end2: end2);

      // Assert
      Assert.isTrue(result);
    });

    test('parallel', () {
      // Arrange
      final start1 = Vector2(1, 1);
      final end1 = Vector2(10, 10);

      final start2 = Vector2(2, 1);
      final end2 = Vector2(10, 9);

      // Act
      final result = InGameMath.doTwoSegmentsIntersect(start1: start1, end1: end1, start2: start2, end2: end2);

      // Assert
      Assert.isFalse(result);
    });

    test('the same', () {
      // Arrange
      final start1 = Vector2(1, 1);
      final end1 = Vector2(10, 10);

      final start2 = Vector2(1, 1);
      final end2 = Vector2(10, 10);

      // Act
      final result = InGameMath.doTwoSegmentsIntersect(start1: start1, end1: end1, start2: start2, end2: end2);

      // Assert
      Assert.isFalse(result);
    });

    test('full overlay', () {
      // Arrange
      final start1 = Vector2(1, 1);
      final end1 = Vector2(10, 10);

      final start2 = Vector2(2, 2);
      final end2 = Vector2(9, 9);

      // Act
      final result = InGameMath.doTwoSegmentsIntersect(start1: start1, end1: end1, start2: start2, end2: end2);

      // Assert
      Assert.isFalse(result);
    });

    test('partial overlay', () {
      // Arrange
      final start1 = Vector2(1, 1);
      final end1 = Vector2(9, 9);

      final start2 = Vector2(2, 2);
      final end2 = Vector2(10, 10);

      // Act
      final result = InGameMath.doTwoSegmentsIntersect(start1: start1, end1: end1, start2: start2, end2: end2);

      // Assert
      Assert.isFalse(result);
    });

    test("don't cross", () {
      // Arrange
      final start1 = Vector2(2, 1);
      final end1 = Vector2(10, 1);

      final start2 = Vector2(1, 2);
      final end2 = Vector2(1, 10);

      // Act
      final result = InGameMath.doTwoSegmentsIntersect(start1: start1, end1: end1, start2: start2, end2: end2);

      // Assert
      Assert.isFalse(result);
    });

    test("have the same vertex", () {
      // Arrange
      final start1 = Vector2(1, 1);
      final end1 = Vector2(10, 1);

      final start2 = Vector2(1, 1);
      final end2 = Vector2(1, 10);

      // Act
      final result = InGameMath.doTwoSegmentsIntersect(start1: start1, end1: end1, start2: start2, end2: end2);

      // Assert
      Assert.isFalse(result);
    });
  });
}
