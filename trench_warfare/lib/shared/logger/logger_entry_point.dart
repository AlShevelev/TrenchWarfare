part of logger;

class Logger {
  static late final Talker talkerFlutter;

  static const bool turnedOff = appFlavor != 'withLog';

  static void init() {
    if (turnedOff) return;

    talkerFlutter = Talker(
      history: _TalkerDbHistory(dao: Database.talkerHistoryDao),
    );
  }

  static void info(String message, {String? tag, Object? exception, StackTrace? stackTrace}) => _log(
        message: message,
        tag: tag,
        exception: exception,
        stackTrace: stackTrace,
        level: LogLevel.info,
      );

  static void debug(String message, {String? tag, Object? exception, StackTrace? stackTrace}) => _log(
    message: message,
    tag: tag,
    exception: exception,
    stackTrace: stackTrace,
    level: LogLevel.debug,
  );

  static void verbose(String message, {String? tag, Object? exception, StackTrace? stackTrace}) => _log(
    message: message,
    tag: tag,
    exception: exception,
    stackTrace: stackTrace,
    level: LogLevel.verbose,
  );

  static void warn(String message, {String? tag, Object? exception, StackTrace? stackTrace}) => _log(
    message: message,
    tag: tag,
    exception: exception,
    stackTrace: stackTrace,
    level: LogLevel.warning,
  );

  static void error(String message, {String? tag, Object? exception, StackTrace? stackTrace}) => _log(
    message: message,
    tag: tag,
    exception: exception,
    stackTrace: stackTrace,
    level: LogLevel.error,
  );

  static void critical(String message, {String? tag, Object? exception, StackTrace? stackTrace}) => _log(
    message: message,
    tag: tag,
    exception: exception,
    stackTrace: stackTrace,
    level: LogLevel.critical,
  );

  static void _log({
    required String message,
    String? tag,
    Object? exception,
    StackTrace? stackTrace,
    required LogLevel level,
  }) {
    if (turnedOff) return;

    final resultMessage = tag == null ? message : '[$tag] $message';
    talkerFlutter.log(resultMessage, logLevel: level, exception: exception, stackTrace: stackTrace);
  }
}
