import 'package:logger/logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';

class AppLogger {
  static final AppLogger _appLogger = AppLogger._internal();

  factory AppLogger() => _appLogger;

  AppLogger._internal();

  final Logger _logger = Logger();

  void log({required String message, LogLevel logLevel = LogLevel.warning}) {
    switch (logLevel) {
      case LogLevel.trace:
        _logger.t(message);
        break;
      case LogLevel.debug:
        _logger.d(message);
        break;
      case LogLevel.info:
        _logger.i(message);
        break;
      case LogLevel.warning:
        _logger.w(message);
        break;
      case LogLevel.error:
        _logger.e(message);
        break;
      case LogLevel.fatal:
        _logger.f(message);
        break;
    }
  }
}
