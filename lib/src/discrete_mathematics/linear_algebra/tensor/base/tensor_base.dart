import '../../../../mixins/copyable_mixin.dart';

/// Base class for tensor
abstract class TensorBase<T> with CopyableMixin<TensorBase<T>> {
  /// Creates instanse of TensorBase with dimension
  TensorBase(this._dimension);

  /// Holds dimension of this tensor
  int _dimension;

  /// Gets dimendion of this tensor
  int get dimension => _dimension;
}
