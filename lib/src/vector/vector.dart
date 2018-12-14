import 'dart:math';

import '../exceptions/vector_exception.dart';
import '../matrix/matrix.dart';
import '../matrix/square_matrix.dart';
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

  @override
  Vector crossProduct(VectorBase vector) {
    if (itemCount == 3 && vector.itemCount == 3) {
      final m = SquareMatrix(<List<double>>[
        <double>[1, 1, 1],
        data,
        vector.data
      ]);

      final v = <double>[];
      for (var i = 1; i <= m.columns; i++) {
        v.add(m.removeRow(1).removeColumn(i).toSquareMatrix().getDeterminant());
      }
      return Vector(v);
    } else {
      throw VectorException(
          'Vectors should be in three-dimensional Euclidean space.'
          'Found $itemCount and ${vector.itemCount}');
    }
  }
}
