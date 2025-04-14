part of simple_profiler;

class _Instant {
  final String _tag;

  int _counter = 0;

  _Instant({required String tag}) : _tag = tag;

  void register() {
    _counter++;
  }

  @override
  String toString() => 'Instant[$_tag]: total calls: $_counter';
}
