/*
 * Trench Warfare - turn-based strategy game in the WWI setting
 * ---
 * Copyright (c) 2025 by Alexander Shevelev
 * ---
 * https://github.com/AlShevelev
 * https://medium.com/@al-e-shevelev
 * al.e.shevelev@gmail.com
 */

part of streams;

abstract class SimpleStream<T> {
  late final StreamController<T> _stream = getStreamController();

  Sink<T> get _input => _stream.sink;

  Stream<T> get output => _stream.stream;

  T? _currentValue;

  T? get current => _currentValue;

  void update(T value) {
    if (!_stream.isClosed) {
      _currentValue = value;
      _input.add(value);
    }
  }

  void close() {
    _stream.close();
  }

  @protected
  StreamController<T> getStreamController();
}
