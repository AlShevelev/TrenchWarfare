import 'package:talker_flutter/talker_flutter.dart';

class Logger {
  static late final Talker talkerFlutter;

  static void init() {
    talkerFlutter = Talker();
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
    final resultMessage = tag == null ? message : '[$tag] $message';
    talkerFlutter.log(resultMessage, logLevel: level, exception: exception, stackTrace: stackTrace);
  }
}
