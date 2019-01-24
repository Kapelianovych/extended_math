import 'base/tensor_base.dart';

/// Class for work with 4 dimensional tensor
class Tensor4 extends TensorBase {
  /// Creates [Tensor4] with data
  Tensor4(this._data) : super(4);

  List<List<List<List<num>>>> _data;
  
  @override
  Tensor4 copy() {
    final data = _data.map(
      (r) => r.map(
        (z) => z.map(
          (u) => u.toList()).toList()).toList()).toList();
    return Tensor4(data);
  }

  @override
  String toString() => '$_data';
}