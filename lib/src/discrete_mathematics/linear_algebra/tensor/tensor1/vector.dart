import 'dart:math';

import 'package:quiver/core.dart';

import '../../../general_algebraic_systems/number/base/number.dart';
import '../../../general_algebraic_systems/number/exception/division_by_zero_exception.dart';
import '../../exceptions/vector_exception.dart';
import '../base/tensor_base.dart';
import '../tensor2/matrix.dart';
import '../tensor2/square_matrix.dart';

/// Class for work with vectors
class Vector extends TensorBase {
  /// Inits data for vector
  Vector(this._data) : super(1);

  /// Data for vector
  List<num> _data;

  /// Gets data of this vector
  List<num> get data => _data.toList();

  /// Count of vector's numbers
  int get itemCount => _data.length;

  /// Gets length of this vector
  num get length => euclideanNorm();

  /// Gets number at specified [index]
  ///
  /// [index] is in range from 1 to end inclusively.
  num itemAt(int index) => _data[index - 1];

  /// Sets [item] in specified [position] of vector
  ///
  /// [position] should starts from 1.
  void setItem(int position, num item) {
    _data[position - 1] = item;
  }

  /// Gets norm of vector alse known as vector's length
  ///
  /// [p] should have only integer value, if not - any fractional digits will be discarded.
  num norm(double p) {
    final n = p.truncateToDouble();
    if (n <= 0) {
      throw VectorException('P must be greater or equal to 1! Given $p.');
    } else if (n.isInfinite) {
      var res = itemAt(1);
      for (var i in _data) {
        if (res < i) {
          res = i;
        }
      }
      return res;
    } else {
      var sum = 0.0;
      for (var item in _data) {
        sum += pow(item, n);
      }
      return pow(sum, 1 / n);
    }
  }

  /// Gets Euclidean norm
  num euclideanNorm() => norm(2);

  /// Gets the norm where p is infinite
  num maxNorm() => norm(double.infinity);

  /// Multiply this vector by [vector] using dot product algorithm
  num dotProduct(Vector vector) =>
      toMatrixRow().matrixProduct(vector.toMatrixColumn()).itemAt(1, 1);

  /// Converts this vector to matrix with one column
  Matrix toMatrixColumn() {
    final matrix = _data.map((value) => <num>[value]).toList();
    return Matrix(matrix);
  }

  /// Convert this vector to martix with one row
  Matrix toMatrixRow() => Matrix(<List<num>>[_data]);

  /// Gets cross product of this vector and another [vector]
  ///
  /// Only suited for three-dimensional Euclidean space.
  /// [itemCount] of both vectors must be equal to 3.
  Vector crossProduct(Vector vector) {
    if (itemCount == 3 && vector.itemCount == 3) {
      final v = <num>[];
      for (var i = 1; i <= 3; i++) {
        final m = SquareMatrix(<List<num>>[
          <num>[1, 1, 1],
          _data,
          vector._data
        ]);
        m
          ..removeRow(1)
          ..removeColumn(i);
        v.add(m.determinant());
      }
      return Vector(v);
    } else {
      throw VectorException(
          'Vectors should be in three-dimensional Euclidean space.'
          'Found $itemCount and ${vector.itemCount}');
    }
  }

  /// Get angle between this vector and another [vector]
  ///
  /// Dafault unit for measuring angle is `radian`.
  /// If [degrees] is true - result will have the degrees unit.
  double angleBetween(Vector vector, {bool degrees = false}) {
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
  Vector hadamardProduct(Vector vector) {
    final _data = <num>[];
    for (var i = 1; i <= itemCount; i++) {
      _data.add(itemAt(i) * vector.itemAt(i));
    }
    return Vector(_data);
  }

  /// Transform each element of this vector and return transformed vector
  Vector transform(num t(num value)) => Vector(_data.map(t).toList());

  /// Checks if vector is unit vector
  bool isUnit() => euclideanNorm() == 1;

  /// Checks if this vector and [vector] are orthogonal to each other
  bool isOrthogonalTo(Vector vector) => dotProduct(vector) == 0;

  /// Checks if this vector and [vector] are orthonormal
  bool isOrthonormalWith(Vector vector) =>
      isOrthogonalTo(vector) && isUnit() && vector.isUnit();

  /// Multiplies this vector by number or other vector
  ///
  /// When multiplying two vectors, Hadamard's product is used.
  Vector operator *(Object other) {
    Vector v;
    if (other is num) {
      v = transform((v) => v * other);
    } else if (other is Vector) {
      v = hadamardProduct(other);
    } else if (other is Number) {
      v = transform((v) => v * other.toDouble());
    }
    return v;
  }

  /// Divides corresponding values of this vactors by [other]
  Vector operator /(Object other) {
    Vector v;
    if (other is num) {
      if (other == 0) {
        throw DivisionByZeroException();
      }
      v = this * (1 / other);
    } else if (other is Number) {
      if (other.toDouble() == 0) {
        throw DivisionByZeroException();
      }
      v = this * (1 / other.toDouble());
    }
    return v;
  }

  /// Gets unary minus of this vector
  Vector operator -() => transform((v) => -v);

  /// Add values of this vector to [vector]'s values
  Vector operator +(Vector vector) {
    if (itemCount == vector.itemCount) {
      final tmpData = <num>[];
      for (var i = 1; i <= itemCount; i++) {
        tmpData.add(itemAt(i) + vector.itemAt(i));
      }
      return Vector(tmpData);
    } else {
      throw VectorException('Count of vector\'s numbers isn\'t equal!');
    }
  }

  /// Subtract [vector]'s values from values of this vector
  Vector operator -(Vector vector) => this + -vector;

  @override
  bool operator ==(Object other) =>
      other is Vector && hashCode == other.hashCode;

  @override
  int get hashCode => hashObjects(_data);

  @override
  String toString() => '$_data';

  @override
  Vector copy() => Vector(_data);
}
