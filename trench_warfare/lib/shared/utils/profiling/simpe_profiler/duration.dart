part of simple_profiler;

class _Duration {
  final String _tag;

  int _counter = 0;

  Duration _totalDuration = Duration.zero;

  Stopwatch? _stopwatch;

  _Duration({required String tag}) : _tag = tag;

  void registerStart() {
    _stopwatch = Stopwatch()..start();
  }

  void registerStop() {
    final stopwatch = _stopwatch;

    if (stopwatch == null) {
      return;
    }

    stopwatch.stop();
    _totalDuration += stopwatch.elapsed;

    _counter++;
  }

  @override
  String toString() {
    final averageDuration = Duration(microseconds: _totalDuration.inMicroseconds ~/ _counter);
    return 'Duration[$_tag]: total calls: $_counter; total duration: $_totalDuration; average duration: $averageDuration';
  }
}
