import 'dart:math';

class RandomGen {
  static final Random _random = Random(DateTime.now().millisecond);

  static double random(double min, double max) => _random.nextDouble() * (max - min) + min;

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
}