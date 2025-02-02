import 'package:flutter/widgets.dart';
import 'package:trench_warfare/shared/architecture/async_signal.dart';

abstract interface class GamePauseWait {
  Future<void> wait();
}

class GamePause implements GamePauseWait {
  final AsyncSignal _asyncSignal = AsyncSignal(locked: false);

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  void attachLifecycleNotifier(ValueNotifier<AppLifecycleState> lifecycleNotifier) {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    lifecycleNotifier.addListener(_handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    _asyncSignal.close();
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
        {
          _asyncSignal.lock();
          break;
        }
      case AppLifecycleState.resumed:
        {
          _asyncSignal.unlock();
          break;
        }
      default: {
        // No need to react to other states
      }
    }
  }

  @override
  Future<void> wait() async {
    await _asyncSignal.wait();
  }
}