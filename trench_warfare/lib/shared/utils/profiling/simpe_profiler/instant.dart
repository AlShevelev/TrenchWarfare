/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

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
