/// Exception that throws while perform improper elementary operations
class EquationException implements Exception {
  /// Take [message] that describe reason of exception
  EquationException(this.message);

  /// Field that contain reason of exception
  String message;

  @override
  String toString() => '$message';
}
