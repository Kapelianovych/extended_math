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

  /// Gets length of this vector
  double get length => euclideanNorm();

  /// Gets number at specified [index]
  ///
  /// [index] is in range from 1 to end inclusively.
  double itemAt(int index) => data[index - 1];

  /// Sets [item] in specified [position] of vector
  ///
  /// [position] should starts from 1.
  void setItem(int position, double item) {
    data[position - 1] = item;
  }

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

  /// Multiply this vector by [vector] using dot product algorithm
  double dotProduct(covariant VectorBase vector) =>
      toMatrix().transpose().multiplyByMatrix(vector.toMatrix()).itemAt(1, 1);

  /// Gets cross product of this vector and another [vector]
  ///
  /// Only suited for three-dimensional Euclidean space.
  /// [itemCount] of both vectors must be equal to 3.
  VectorBase crossProduct(covariant VectorBase vector);

  /// Add this vector to [vector]
  VectorBase add(covariant VectorBase vector);

  /// Subtract this vector from [vector]
  VectorBase subtract(covariant VectorBase vector);

  /// Convert this vector to martix
  MatrixBase toMatrix();

  /// Get angle between this vector and another [vector]
  ///
  /// Dafault unit for measuring angle is `radian`.
  /// If [degrees] is true - result will have the degrees unit.
  double angleBetween(covariant VectorBase vector, {bool degrees = false}) {
    final dot = dotProduct(vector);
    final magnitudes = euclideanNorm() * vector.euclideanNorm();
    if (degrees == false) {
      return acos(dot / magnitudes);
    } else {
      // Cast from radians to degrees
      // 1 rad = 57.295779513 degrees.
      return acos(dot / magnitudes) * 57.295779513;
    }
  }

  /// Gets Hadamard product of vectors
  VectorBase hadamardProduct(covariant VectorBase vector);

  /// Transform each element of this vector and return transformed vector
  VectorBase transform(double t(double value));

  /// Checks if vector is unit vector
  bool isUnit() => euclideanNorm() == 1;

  /// Checks if this vector and [vector] are orthogonal to each other
  bool isOrthogonalTo(covariant VectorBase vector) => dotProduct(vector) == 0;

  /// Checks if this vector and [vector] are orthonormal
  bool isOrthonormalWith(covariant VectorBase vector) =>
      isOrthogonalTo(vector) && isUnit() && vector.isUnit();
}
