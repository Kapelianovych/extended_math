import 'tensor_exception.dart';

/// An exception that trows when performing improper matrix operations.
class MatrixException extends TensorException implements Exception {
  /// Take [message] that describe reason of exception
  MatrixException(String message) : super(message);
}
