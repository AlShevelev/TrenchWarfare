/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

T estimateCallTime<T>(T Function() action, {String tag = ""}) {
  final stopwatch = Stopwatch()..start();
  final result = action();
  print('$tag: The function executed in ${stopwatch.elapsed}');

  return result;
}

Future<T> estimateCallTimeAsync<T>(Future<T> Function() action, {String tag = ""}) async {
  final stopwatch = Stopwatch()..start();
  final result = await action();
  print('$tag: The function executed in ${stopwatch.elapsed}');

  return result;
}
