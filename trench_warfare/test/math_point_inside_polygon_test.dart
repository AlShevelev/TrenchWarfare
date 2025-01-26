import 'package:flame/components.dart';
import 'package:test/test.dart';
import 'package:trench_warfare/shared/utils/math.dart';

import 'assert.dart';

void main() {
  group('math - PointInsidePolygon', () {
    test('inside', () {
      // Arrange
      final polygon = [
        Vector2(1, 1),
        Vector2(3, 1),
        Vector2(3, 3),
        Vector2(1, 3),
      ];

      final point = Vector2(2, 2);

      // Act
      final result = InGameMath.isPointInsidePolygon(point, polygon);

      // Assert
      Assert.isTrue(result);
    });

    test('outside - above', () {
      // Arrange
      final polygon = [
        Vector2(1, 1),
        Vector2(3, 1),
        Vector2(3, 3),
        Vector2(1, 3),
      ];

      final point = Vector2(2, 0);

      // Act
      final result = InGameMath.isPointInsidePolygon(point, polygon);

      // Assert
      Assert.isFalse(result);
    });

    test('outside - below', () {
      // Arrange
      final polygon = [
        Vector2(1, 1),
        Vector2(3, 1),
        Vector2(3, 3),
        Vector2(1, 3),
      ];

      final point = Vector2(2, 4);

      // Act
      final result = InGameMath.isPointInsidePolygon(point, polygon);

      // Assert
      Assert.isFalse(result);
    });

    test('outside - left', () {
      // Arrange
      final polygon = [
        Vector2(1, 1),
        Vector2(3, 1),
        Vector2(3, 3),
        Vector2(1, 3),
      ];

      final point = Vector2(0, 2);

      // Act
      final result = InGameMath.isPointInsidePolygon(point, polygon);

      // Assert
      Assert.isFalse(result);
    });

    test('outside - right', () {
      // Arrange
      final polygon = [
        Vector2(1, 1),
        Vector2(3, 1),
        Vector2(3, 3),
        Vector2(1, 3),
      ];

      final point = Vector2(4, 2);

      // Act
      final result = InGameMath.isPointInsidePolygon(point, polygon);

      // Assert
      Assert.isFalse(result);
    });

    test('outside - corner', () {
      // Arrange
      final polygon = [
        Vector2(1, 1),
        Vector2(3, 1),
        Vector2(3, 3),
        Vector2(1, 3),
      ];

      final point = Vector2(0, 0);

      // Act
      final result = InGameMath.isPointInsidePolygon(point, polygon);

      // Assert
      Assert.isFalse(result);
    });
  });
}
