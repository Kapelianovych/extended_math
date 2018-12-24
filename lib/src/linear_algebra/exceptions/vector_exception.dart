/// An exception that trows when performing improper vector operations.
class VectorException implements Exception {
  /// Take [message] that describe reason of exception
  VectorException(this.message);

  /// Field that contain reason of exception
  String message;

  @override
  String toString() => '$message';
}
