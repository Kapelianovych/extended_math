import '../matrix/matrix.dart';
import 'base/vector_base.dart';

/// Class for work with vectors
class Vector extends VectorBase {
  /// Inits [data] for vector
  Vector(List<double> data) : super.init(data);

  @override
  int get itemCount => data.length;

  @override
  double dot(VectorBase vector) =>
      toMatrix().transpose().multiplyByMatrix(vector.toMatrix()).data[0][0];

  @override
  Matrix toMatrix() {
    final matrix = data.map((value) => <double>[value]).toList();
    return Matrix(matrix);
  }
}
