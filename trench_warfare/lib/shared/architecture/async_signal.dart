import 'dart:async';

class AsyncSignal {
  final _controller = StreamController<bool>.broadcast();

  /// Stream of the signal state.
  Stream<bool> get stream => _controller.stream;

  /// Future with the next signal state.
  Future<bool> get future => _controller.stream.first;

  bool _locked;

  /// Set the signal state. This works the same as [lock] and [unlock] methods.
  bool get locked => _locked;
  set locked(bool locked) {
    _locked = locked;
    _controller.add(_locked);
  }

  AsyncSignal({bool locked = false}) : _locked = locked;

  /// Locking will prevent everyone waiting from passing through, until unlocked.
  void lock() => locked = true;

  /// Unlocking will allow everyone who was waiting to pass through.
  void unlock() => locked = false;

  /// Wait until the signal is unlocked.
  /// If the signal is already unlocked, this will continue immediately.
  FutureOr<bool?> wait() {
    return !locked ? null : stream.firstWhere((locked) => locked == false);
  }

  /// Closing the signal will make it not signal any future waiting tasks.
  void close() => _controller.close();

  void unlockAndClose() {
    if (_locked) {
      unlock();
    }

    close();
  }
}