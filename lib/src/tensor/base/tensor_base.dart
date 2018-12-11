/// Base class for tensor
abstract class TensorBase<T> {
  /// Default constructor that don't accept data
  TensorBase();

  /// Constructor that accept [data]
  TensorBase.init(this.data);

  /// Data for tensor
  List<List<List<T>>> data;
}
