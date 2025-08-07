import 'dart:developer' as developer;

class Logger {
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: 'FirebaseDemoApp',
      error: error,
      stackTrace: stackTrace,
      level: 1000, // Corresponds to SEVERE level
    );
  }
}
