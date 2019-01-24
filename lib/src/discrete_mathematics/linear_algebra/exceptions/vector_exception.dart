import 'tensor_exception.dart';

/// An exception that trows when performing improper vector operations
class VectorException extends TensorException {
  /// Take [message] that describe reason of exception
  VectorException(String message) : super(message);
}
