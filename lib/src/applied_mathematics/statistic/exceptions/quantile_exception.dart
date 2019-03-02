import '../quantiles/base/quantile.dart';

/// Exception that is thrown when performing unaccepted operations 
/// with [Quantile] and its derivates
class QuantileException implements Exception {
  /// Creates instence of [QuantileException]
  QuantileException(this.message);

  /// Reason of exception
  final String message;

  @override
  String toString() => message;
}