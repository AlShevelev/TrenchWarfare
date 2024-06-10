import 'dart:developer' as developer;

T estimateCallTime<T>(T Function() action, {String tag = ""}) {
  final stopwatch = Stopwatch()..start();
  final result = action();
  developer.log('${tag}The function executed in ${stopwatch.elapsed}');

  return result;
}
