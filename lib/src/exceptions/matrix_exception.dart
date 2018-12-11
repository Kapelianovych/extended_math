/// An exception that trows when performing improper matrix operations.
class MatrixException implements Exception {
  /// Take [message] that describe reason of exception
  MatrixException(this.message);

  /// Field that contain reason of exception
  String message;

  @override
  String toString() => '$message';
}
