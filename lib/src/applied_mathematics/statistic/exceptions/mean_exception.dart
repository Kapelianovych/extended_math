/// An exception that trows when performing unaccepted opetation or operation under unaccepted values
class MeanException implements Exception {
  /// Creates instance of [MeanException]
  MeanException(this.message);

  /// Reason of exception
  final String message;

  @override
  String toString() => '$message';
}
