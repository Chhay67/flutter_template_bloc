

import 'package:flutter/foundation.dart';


class AppLogger {
  AppLogger._();

  // Optional: allow forcing logs in release with:
  // flutter run --release --dart-define=ENABLE_LOGS=true
  static const bool _forceEnable = bool.fromEnvironment('ENABLE_LOGS', defaultValue: false);

  static bool get _enabled => !kReleaseMode || _forceEnable;

  static const String _reset = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _cyan = '\x1B[36m';
  static void _log({
    String? message,
    StackTrace? stackTrace,
    required String color,
    required String label,
  }) {
    if (!_enabled) return;
    debugPrint('$color $label $_reset $color $message $_reset');
    if (stackTrace != null) debugPrintStack(stackTrace: stackTrace);
  }

  static void info(String message) {
    _log(label: "ℹ️ [INFO]", message: message, color: _cyan);
  }

  static void error(String message, {StackTrace? stackTrace}) {
    _log(
        color: _red,
        label: "❌ [ERROR]",
        stackTrace: stackTrace,
        message: message);
  }

  static void warning(String message) {
    _log(color: _yellow, label: "⚠️ [WARNING]",  message: message);
  }

  static void network(String message) {
    _log(color: _blue, label: "🌐 [NETWORK]",  message: message);
  }

  static void debug(String message) {
    _log(color: _cyan, label: "🐛 [DEBUG]", message: message);
  }

  static void success(String message) {
    _log(color: _green, label: "✅ [SUCCESS]",  message: message);
  }

}