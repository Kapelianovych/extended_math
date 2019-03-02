/// An exception that trows when performing unaccepted operation
/// or operation under unaccepted values
class MeanException implements Exception {
  /// Creates instance of [MeanException]
  MeanException(this.message);

  /// Reason of exception
  final String message;

  @override
  String toString() => '$message';
}
