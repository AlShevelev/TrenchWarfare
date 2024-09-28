part of logger;

class _TalkerDataDbEntityMapper {
  static TalkerDataDbEntity mapToDb(TalkerData data) =>
      TalkerDataDbEntity(
        message: data.message,
        logLevel: data.logLevel?.let((l) => _logLevelToInt(l)),
        title: data.title,
        key: data.key,
        time: data.time,
        penFColor: data.pen?.let((p) => p.fcolor),
        penBColor: data.pen?.let((p) => p.bcolor),
        stackTrace: data.stackTrace?.let((s) => s.toString()),
      );

  static TalkerData mapFromDb(TalkerDataDbEntity data) {
    return TalkerData(
      data.message,
      logLevel: data.logLevel?.let((l) => _logLevelFromInt(l)),
      exception: null,
      error: null,
      stackTrace: data.stackTrace?.let((s) => StackTrace.fromString(s)),
      title: data.title,
      time: data.time,
      pen: AnsiPen()..xterm(data.penFColor ?? -1, bg: false)..xterm(data.penBColor ?? -1, bg: true),
      key: data.key,
    );
  }

  static int _logLevelToInt(LogLevel level) =>
      switch(level) {
        LogLevel.error => 0,
        LogLevel.critical => 1,
        LogLevel.info => 2,
        LogLevel.debug => 3,
        LogLevel.verbose => 4,
        LogLevel.warning => 5
      };

  static LogLevel _logLevelFromInt(int level) =>
      switch(level) {
        0 => LogLevel.error,
        1 => LogLevel.critical,
        2 => LogLevel.info,
        3 => LogLevel.debug,
        4 => LogLevel.verbose,
        5 => LogLevel.warning,
        _ => LogLevel.info
      };
}