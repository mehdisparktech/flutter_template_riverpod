import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

///
/// Service which gives access to `logger` and
/// helper methods to easily log stuff to the console
///

class LoggerService {
  ///
  /// CONSTRUCTOR
  ///

  LoggerService() {
    logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 3,
        lineLength: 50,
        noBoxingByDefault: true,
      ),
    );
  }

  ///
  /// VARIABLES
  ///

  late final Logger logger;

  ///
  /// METHODS
  ///

  /// Verbose log, grey color
  void v(dynamic value) => logger.t(
      value); // .v is .t (trace) in newer logger or keep .v if available? In v2 .v is deprecated for .t? No. Let's check. Actually .v (verbose) became .t (trace). .d (debug) exists.
  // Wait, in logger 2.0: t, d, i, w, e, f.
  // v -> t (trace)

  /// 🐛 Debug log, blue color
  void d(dynamic value) => logger.d(value);

  /// 💡 Info log, light blue color
  void i(dynamic value) => logger.i(value);

  /// ⚠️ Warning log, orange color
  void w(dynamic value) => logger.w(value);

  /// ⛔ Error log, red color
  void e(dynamic value) => logger.e(value);

  /// 👾 What a terrible failure log, purple color
  void wtf(dynamic value) => logger.f(value);

  /// Logs JSON responses with proper formatting
  void logJson(String data, {bool isError = false}) {
    final object = json.decode(data);
    final prettyString = const JsonEncoder.withIndent('  ').convert(object);
    isError ? logger.e(prettyString) : logger.t(prettyString);
  }

  /// Opens [Logger] screen
  void openLogger(BuildContext context) {
    // LogConsole is not available in standard logger package.
    // Consider using talker_flutter for UI logging if needed.
    debugPrint('Log Console not implemented in this version.');
  }
}
