/// An exception that trows when performing improper operations
/// with complex numbers
class ComplexException implements Exception {
  /// Take [message] that describe reason of exception
  ComplexException(this.message);

  /// Field that contain reason of exception
  String message;

  @override
  String toString() => message;
}
