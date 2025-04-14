part of simple_profiler;

class SimpleProfiler {
  static final Map<String, Map<String, _Duration>> _durations = {};

  static final Map<String, Map<String, _Instant>> _instants = {};

  static void registerStart({required String groupName, required String tag}) {
    final group = _durations[groupName];

    if (group == null) {
      _durations[groupName] = {tag: _Duration(tag: tag)..registerStart()};
    } else {
      final durationValue = group[tag];

      if (durationValue == null) {
        group[tag] = _Duration(tag: tag)..registerStart();
      } else {
        durationValue.registerStart();
      }
    }
  }

  static void registerStop({required String groupName, required String tag}) {
    final group = _durations[groupName];

    if (group != null) {
      group[tag]?.registerStop();
    }
  }

  static void registerInstant({required String groupName, required String tag}) {
    final group = _instants[groupName];

    if (group == null) {
      _instants[groupName] = {tag: _Instant(tag: tag)..register()};
    } else {
      final instantValue = group[tag];

      if (instantValue == null) {
        group[tag] = _Instant(tag: tag)..register();
      } else {
        instantValue.register();
      }
    }
  }

  static void clear() {
    _durations.clear();
    _instants.clear();
  }

  static void log() {
    const tag = 'SIMPLE_PROFILER';

    Logger.info('------ SIMPLE_PROFILER ------', tag: tag);

    Logger.info('--- Durations ---', tag: tag);

    for (final entry in _durations.entries) {
      Logger.info('Group: ${entry.key}', tag: tag);

      for (final duration in entry.value.values) {
        Logger.info('Duration: $duration', tag: tag);
      }
    }

    Logger.info('--- Instants ---', tag: tag);

    for (final entry in _instants.entries) {
      Logger.info('Group: ${entry.key}', tag: tag);

      for (final instant in entry.value.values) {
        Logger.info('Instant: $instant', tag: tag);
      }
    }
  }
}
