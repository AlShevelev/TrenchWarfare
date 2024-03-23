import 'dart:ui';

import 'package:flame/components.dart';
import 'package:tuple/tuple.dart';

/// This is the so-called Cantor pairing function
/// https://en.wikipedia.org/wiki/Pairing_function#Cantor_pairing_function
int pair(int a, int b) {
  final c = a + b;
  final d = c + 1;

  return ((c * d) >> 1) + b;
}

/// Do the two line segments intersect?
bool doTwoSegmentsIntersect({required Vector2 start1, required Vector2 end1, required Vector2 start2, required Vector2 end2}) {
  final dir1 = end1 - start1;
  final dir2 = end2 - start2;

  // the first segment's equation
  final a1 = -dir1.y;
  final b1 = dir1.x;
  final d1 = -(a1*start1.x + b1*start1.y);

  // the second segment's equation
  final a2 = -dir2.y;
  final b2 = dir2.x;
  final d2 = -(a2*start2.x + b2*start2.y);

  // substitute the ends of the segments to find out in which half-planes they are
  final seg1Seg2Start = a2*start1.x + b2*start1.y + d2;
  final seg1Seg2End = a2*end1.x + b2*end1.y + d2;

  final seg2Seg1Start = a1*start2.x + b1*start2.y + d1;
  final seg2Seg1End = a1*end2.x + b1*end2.y + d1;

  // if the ends of one segment have the same sign, then it is in the same half-plane and there is no intersection.
  if (seg1Seg2Start * seg1Seg2End >= 0 || seg2Seg1Start * seg2Seg1End >= 0) {
    return false;
  }

  return true;
}

/// The ray tracing alg
/// [polygon] a polygon is defined as a set of its vertices
bool isPointInsidePolygon(Vector2 point, List<Vector2> polygon) {
  if (polygon.length < 3) {
    throw ArgumentError('Quantity of vertices in the polygon must be greater than 2');
  }

  final point2 = Vector2(point.x, 100000);

  var intersectCounter = 0;
  for(var i = 0; i < polygon.length - 1; i++) {
    if (doTwoSegmentsIntersect(start1: point, end1: point2, start2: polygon[i], end2: polygon[i+1])) {
      intersectCounter++;
    }
  }

  if (doTwoSegmentsIntersect(start1: point, end1: point2, start2: polygon.first, end2: polygon.last)) {
    intersectCounter++;
  }

  return intersectCounter % 2 == 1;
}

bool isPointInsideRect(Vector2 point, Rect rect) =>
  point.x >= rect.left && point.x <= rect.right && point.y >= rect.top && point.y <= rect.bottom;

Rect getBoundRectForPolygon(List<Vector2> polygon) {
  if (polygon.length < 3) {
    throw ArgumentError('Quantity of vertices in the polygon must be greater than 2');
  }

  var minX = 100000.0;
  var minY = 100000.0;
  var maxX = -100000.0;
  var maxY = -100000.0;

  for(var vertex in polygon) {
    if (vertex.x < minX) {
      minX = vertex.x;
    }

    if (vertex.x > maxX) {
      maxX = vertex.x;
    }

    if (vertex.y < minY) {
      minY = vertex.y;
    }

    if (vertex.y > maxY) {
      maxY = vertex.y;
    }
  }

  return Rect.fromLTRB(minX, minY, maxX, maxY);
}

/// [parts] is  monotonically increasing sequence
/// For example, if we would like to split a line into 25%-50%-25% parts
/// it must contain next values: [0.25, 0.75]
List<Tuple2<Offset, Offset>> splitLine(List<double> parts, {required Offset start, required Offset end}) {
  Offset getPointOnLine(double part, {required Offset start, required Offset end}) =>
    Offset(start.dx + (end.dx - start.dx) * part, start.dy + (end.dy - start.dy) * part);

  final List<Tuple2<Offset, Offset>> result = [];

  var activeStart = start;

  for (var part in parts) {
    final activeEnd = getPointOnLine(part, start: start, end: end);
    result.add(Tuple2(activeStart, activeEnd));
    activeStart = activeEnd;
  }

  result.add(Tuple2(activeStart, end));   // the last one

  return result;
}

int multiplyBy(int value, double factor) => (value * factor).round();
