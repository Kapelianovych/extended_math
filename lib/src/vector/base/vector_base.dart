import 'dart:math';

import '../../exceptions/vector_exception.dart';
import '../../matrix/base/matrix_base.dart';

/// Base class for vector
abstract class VectorBase {
  /// Default constructor that don't accept data
  VectorBase();

  /// Constructor that accept [data]
  VectorBase.init(this.data);

  /// Data for vector
  List<double> data;

  /// Count of vector's numbers
  int get itemCount => data.length;

  /// Gets number at specified [index]
  ///
  /// [index] is in range from 1 to end inclusively.
  double itemAt(int index) => data[index - 1];

  /// Gets norm of vector alse known as vector's length
  /// 
  /// [p] should have only integer value, if not - any fractional digits will be discarded.
  double norm(double p) {
    final n = p.truncateToDouble();
    if (n <= 0) {
      throw VectorException('P must be greater or equal to 1! Given $p.');
    } else if (n.isInfinite) {
      var res = itemAt(1);
      for (var i in data) {
        if (res < i) {
          res = i;
        }
      }
      return res;
    } else {
      var sum = 0.0;
      for (var item in data) {
        sum += pow(item, n);
      }
      return pow(sum, 1 / n);
    }
  }

  /// Gets Euclidean norm
  double euclideanNorm() => norm(2);

  /// Gets the norm where p is infinite
  double maxNorm() => norm(double.infinity);

  /// Multiply this vector by [vector]
  double dot(VectorBase vector) =>
      toMatrix().transpose().multiplyByMatrix(vector.toMatrix()).itemAt(1, 1);

  /// Add this vector to [vector]
  VectorBase add(VectorBase vector);

  /// Subtract this vector from [vector]
  VectorBase subtract(VectorBase vector);

  /// Convert this vector to martix
  MatrixBase toMatrix();

  /// Get angle between this vector and another [vector]
  /// 
  /// Dafault unit for measuring angle is `radian`.
  /// If [degrees] is true - result will have the degrees unit.
  double angleBetween(VectorBase vector, {bool degrees = false}) {
    final dotProduct = dot(vector);
    final magnitudes = euclideanNorm() * vector.euclideanNorm();
    if (degrees == false) {
      return acos(dotProduct / magnitudes);
    } else {
      // Cast from radians to degrees
      // 1 rad = 57.295779513 degrees.
      return acos(dotProduct / magnitudes) * 57.295779513;
    }
  }
}
