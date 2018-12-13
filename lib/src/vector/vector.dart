import '../exceptions/vector_exception.dart';
import '../matrix/matrix.dart';
import 'base/vector_base.dart';

/// Class for work with vectors
class Vector extends VectorBase {
  /// Inits [data] for vector
  Vector(List<double> data) : super.init(data);

  @override
  Vector add(VectorBase vector) {
    if (itemCount == vector.itemCount) {
      final tmpData = <double>[];
      for (var i = 1; i <= itemCount; i++) {
        tmpData.add(itemAt(i) + vector.itemAt(i));
      }
      return Vector(tmpData);
    } else {
      throw VectorException('Count of vector\'s numbers isn\'t equal!');
    }
  }

  @override
  Vector subtract(VectorBase vector) {
    if (itemCount == vector.itemCount) {
      final tmpData = <double>[];
      for (var i = 1; i <= itemCount; i++) {
        tmpData.add(itemAt(i) - vector.itemAt(i));
      }
      return Vector(tmpData);
    } else {
      throw VectorException('Count of vector\'s numbers isn\'t equal!');
    }
  }

  @override
  Matrix toMatrix() {
    final matrix = data.map((value) => <double>[value]).toList();
    return Matrix(matrix);
  }
}
