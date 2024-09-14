import 'dart:math';

import 'package:collection/collection.dart';

class RandomGen {
  static final Random _random = Random(DateTime.now().millisecondsSinceEpoch);

  static double randomDouble(double min, double max) => _random.nextDouble() * (max - min) + min;

  static int randomInt(int max) => _random.nextInt(max);

  static String generateId() {
    const String hexDigits = "0123456789abcdef";
    final List<String> uuid = [];

    for (int i = 0; i < 36; i++) {
      final int hexPos = _random.nextInt(16);
      uuid.add((hexDigits.substring(hexPos, hexPos + 1)));
    }

    // bits 6-7 of the clock_seq_hi_and_reserved to 01
    int pos = (int.parse(uuid[19], radix: 16) & 0x3) | 0x8;

    // bits 12-15 of the time_hi_and_version field to 0010
    uuid[14] = "4";
    uuid[19] = hexDigits.substring(pos, pos + 1);

    uuid[8] = uuid[13] = uuid[18] = uuid[23] = "-";

    final StringBuffer buffer = StringBuffer();
    buffer.writeAll(uuid);
    return buffer.toString();
  }

  /// Returns an index of a cell in the [weights] list.
  /// The probability is in direct ratio with a weight value
  /// If the result is null - the selection is impossible
  static int? randomWeight(Iterable<double> weights) {
    if (weights.isEmpty) {
      return null;
    }

    if (weights.length == 1) {
      return 0;
    }

    final sum = weights.sum;

    if (sum == 0) {
      return null;
    }

    final randomValue = _random.nextDouble();

    var from = 0.0;
    var to = 0.0;

    for (var i = 0; i < weights.length; i++) {
      final currentWeight = weights.elementAt(i);

      if (currentWeight < 0) {
        return null;
      }

      to += weights.elementAt(i) / sum;

      if (randomValue >= from && randomValue < to) {
        return i;
      }

      from  = to;
    }

    return weights.length - 1;
  }
}