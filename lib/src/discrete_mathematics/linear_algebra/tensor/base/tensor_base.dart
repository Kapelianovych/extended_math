import '../../../../mixins/copyable_mixin.dart';

/// Base class for tensors
abstract class TensorBase with CopyableMixin<TensorBase> {
  /// Creates instanse of TensorBase with dimensions
  TensorBase(this._dimensions);

  /// Holds rank of this tensor
  int _dimensions;

  /// Gets dimendion of this tensor
  int get dimensions => _dimensions;
}
