/// An exception that trows when performing improper tensor operations
class TensorException implements Exception {
  /// Take [message] that describe reason of exception
  TensorException(this.message);

  /// Field that contain reason of exception
  String message;

  @override
  String toString() => '$message';
}
