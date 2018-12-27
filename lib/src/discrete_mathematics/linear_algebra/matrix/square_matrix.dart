import 'dart:math';

import '../../../general/elementary_algebra/cubic_equation.dart';
import '../../../general/elementary_algebra/quadratic_equation.dart';
import '../exceptions/matrix_exception.dart';
import '../vector/vector.dart';
import 'matrix.dart';

/// Class for work with numeric square matrix
class SquareMatrix extends Matrix {
  /// Constructor accept array of arrays of double numbers
  ///
  /// Count of inner arrays must be equal to count of their elements!
  SquareMatrix(List<List<double>> data) : super(<List<double>>[]) {
    if (data.length != data[0].length) {
      throw MatrixException(
          'Count of matrix columns must be equal to count of rows!');
    } else {
      this.data = data;
    }
  }

  /// Generate matrix with specified [number] of rows and columns
  ///
  /// If [fillRandom] is true, then matrix will filled with random numbers,
  /// otherwise matrix will have all values defaults to 0
  SquareMatrix.generate(int number,
      {bool fillRandom = false, bool identity = false})
      : super.generate(number, number,
            fillRandom: fillRandom, identity: identity);

  /// Creates an identity matrix
  SquareMatrix.identity(int number) : super.identity(number, number);

  /// Gets determinant of matrix
  double determinant() {
    final firstRow = rowAt(1);

    if (itemCount == 1) {
      return itemAt(1, 1);
    } else {
      double res = 0;
      for (var i = 0; i < firstRow.length; i++) {
        final changedMatrix =
            SquareMatrix(removeRow(1).removeColumn(i + 1).data);
        res += pow(-1, 1 + (i + 1)) * firstRow[i] * changedMatrix.determinant();
      }
      return res;
    }
  }

  /// Checks if this matrix is singular
  bool isSingular() => determinant() == 0;

  /// Checks if this matrix is singular
  bool isNotSingular() => !isSingular();

  /// Checks if this matrix is symmetric
  bool isSymmetric() {
    for (var r = 1; r <= rows; r++) {
      for (var c = 1; c <= columns; c++) {
        if (itemAt(r, c) != itemAt(c, r)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if this matrix is orthogonal
  bool isOrthogonal() {
    final inversed = inverse();
    final transposed = transpose();

    for (var i = 1; i <= rows; i++) {
      for (var j = 1; j <= columns; j++) {
        if (inversed.itemAt(i, j) != transposed.itemAt(i, j)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Inverse and return inversed matrix
  SquareMatrix inverse() {
    if (isSingular()) {
      throw MatrixException(
          'The inverse is impossible because determinant of matrix equal to zero!');
    } else {
      final origin = SquareMatrix(data);

      final matrixOfCofactors = SquareMatrix.generate(rows);
      for (var i = 1; i <= rows; i++) {
        for (var j = 1; j <= columns; j++) {
          final nData = origin.removeRow(i).removeColumn(j).data;
          final det = SquareMatrix(nData).determinant();
          matrixOfCofactors.setItem(i, j, pow(-1, i + j) * det);
        }
      }

      final adjugatedMatrix = SquareMatrix(matrixOfCofactors.transpose().data);
      final inversedMatrix = adjugatedMatrix.multiplyBy(1 / determinant());
      return SquareMatrix(inversedMatrix.data);
    }
  }

  // TODO(YevhenKap): find eigenvectors
  /// Gets eigenvalues and eigenvectors of this matrix
  Map<String, List<double>> eigenDecomposition() {
    final result = <String, List<double>>{};

    if (rows == 1) {
      result['eigenValues'] = <double>[itemAt(1, 1)];
      result['eigenVectors'] = <double>[1];
    } else if (rows == 2) {
      final b = -(itemAt(1, 1) + itemAt(2, 2));
      final c = determinant();
      final expression = QuadraticEquation(1, b: b, c: c);

      result['eigenValues'] = expression.calculate().toList();
    } else if (rows == 3) {
      final b = mainDiagonal().data.reduce((f, s) => f + s);
      final c = itemAt(1, 2) * itemAt(2, 1) +
          itemAt(2, 3) * itemAt(3, 2) -
          ((itemAt(1, 1) * (itemAt(2, 2) + itemAt(3, 3)) + itemAt(3, 3)) -
              itemAt(1, 3) * itemAt(2, 2) * itemAt(3, 1));
      final d = determinant();

      final expression = CubicEquation(-1, b: b, c: c, d: d);

      result['eigenValues'] = expression.calculate().toList();
    }

    return result;
  }

  // TODO(YevhenKap): realize this method
  /// Singulat value decomposition for this matrix
  Map<String, Vector> svd() {}

  /// Performs Gaussian elimination of this matrix and [equalTo] as right-side of augmented matrix
  ///
  /// [equalTo] should be equal to [rows].
  Vector eliminate(List<double> equalTo) {
    var matrix = SquareMatrix(data);
    final vector = equalTo;

    while (itemAt(1, 1) == 0) {
      final row = matrix.rowAt(1);
      final value = vector.removeAt(0);
      matrix = matrix.removeRow(1).insertRow(row).toSquareMatrix();
      vector.add(value);
    }

    for (var i = 1; i <= rows; i++) {
      final element = itemAt(i, i);
      final row1 = matrix.rowAt(i).map((v) => v / element).toList();
      vector[i - 1] /= element;
      matrix = matrix.insertRow(row1, index: i).toSquareMatrix();

      for (var j = i + 1; j <= columns; j++) {
        final tmpRow = Vector(row1)
            .transform((v) => v * (-1) * itemAt(j, i)) + Vector(rowAt(j));
        vector[j - 1] += vector[i - 1] * (-1) * itemAt(j, i);
        matrix = matrix.insertRow(tmpRow.data, index: j).toSquareMatrix();
      }
    }

    for (var i = rows; i >= 1; i--) {
      final row1 = matrix.rowAt(i);

      for (var j = i - 1; j >= 1; j--) {
        final tmpRow = Vector(row1)
            .transform((v) => v * (-1) * itemAt(j, i)) + Vector(rowAt(j));
        vector[j - 1] += vector[i - 1] * (-1) * itemAt(j, i);
        matrix = matrix.insertRow(tmpRow.data, index: j).toSquareMatrix();
      }
    }

    return Vector(vector);
  }
}
