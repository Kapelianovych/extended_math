/// Base class for tensor
abstract class TensorBase {
  /// Default constructor that don't accept data
  TensorBase();

  /// Constructor that accept [data]
  TensorBase.init(this.data);

  /// Data for tensor
  List<List<List<double>>> data;
}
