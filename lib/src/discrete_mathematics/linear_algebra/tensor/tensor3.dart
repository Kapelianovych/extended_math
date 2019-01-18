import '../matrix/matrix.dart';
import 'base/tensor_base.dart';

/// Class for work with 3 dimensional tensor
class Tensor3 extends TensorBase<List<List<num>>> {
  /// Creates [Tensor3] with data
  Tensor3(this._data) : super(3);

  List<List<List<num>>> _data;

  /// Gets width (rows) of this tensor
  int get width => _data.length;
  /// Gets length (columns) of this tensor
  int get length => _data[0].length;
  /// Gets height of this tensor
  int get height => _data[0][0].length;

  /// Gets two dimensional matrix in specified z position
  /// 
  /// [zPosition] may be in range from 1 to end inclusively.
  Matrix matrixAt(int zPosition) {
    final data = <List<num>>[];
    for (var row in _data) {
      data.add(Matrix(row).columnAt(zPosition));
    }
    return Matrix(data);
  }

  @override
  Tensor3 copy() {
    final data = _data.map((row) => row.map((z) => z.toList()).toList()).toList();
    return Tensor3(data);
  }
}
