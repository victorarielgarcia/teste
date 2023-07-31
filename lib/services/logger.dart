// logger.dart

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static Logger? _logger;

  static void initialize() {
    _logger = Logger(
      filter: ProductionFilter(),
      printer: PrettyPrinter(),
    );
  }

  static void log(String message) {
    _logger?.d(message);
  }

  static void error(String message) {
    _logger?.e(message);
  }

  // Adicione outros métodos conforme necessário
}

class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode;
  }
}
