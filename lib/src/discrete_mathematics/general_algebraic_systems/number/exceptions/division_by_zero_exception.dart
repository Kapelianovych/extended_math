/// An exception that trows when performing division by zero
class DivisionByZeroException implements Exception {
  /// Creates instance of [DivisionByZeroException]
  DivisionByZeroException();

  /// Reason of exception
  final String message = 'Division by zero is prihibited!';

  @override
  String toString() => '$message';
}
