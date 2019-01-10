import 'dart:math';

import 'package:data/matrix.dart' as dd;

import '../../../utils/convert.dart';
import '../exceptions/matrix_exception.dart';
import '../vector/vector.dart';
import 'base/matrix_base.dart';
import 'matrix.dart';

/// Class for work with numeric square matrix
class SquareMatrix extends Matrix {
  /// Constructor accept array of arrays of num numbers
  ///
  /// Count of inner arrays must be equal to count of their elements!
  SquareMatrix(List<List<num>> data) : super(data) {
    if (data.length != data[0].length) {
      throw MatrixException(
          'Count of matrix columns must be equal to count of rows!');
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
  num determinant() {
    final firstRow = rowAt(1);

    if (itemCount == 1) {
      return itemAt(1, 1);
    } else {
      num res = 0;
      for (var i = 1; i <= columns; i++) {
        final changedMatrix = SquareMatrix(data);
        changedMatrix
          ..removeRow(1)
          ..removeColumn(i);
        res += pow(-1, 1 + i) * firstRow[i - 1] * changedMatrix.determinant();
      }
      return res;
    }
  }

  /// Checks if this matrix is singular
  bool isSingular() => determinant() == 0;

  /// Checks if this matrix isn't singular
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
          origin
            ..removeRow(i)
            ..removeColumn(j);
          final det = origin.determinant();
          matrixOfCofactors.setItem(i, j, pow(-1, i + j) * det);
        }
      }

      final adjugatedMatrix = SquareMatrix(matrixOfCofactors.transpose().data);
      final inversedMatrix = adjugatedMatrix * (1 / determinant());
      return SquareMatrix(inversedMatrix.data);
    }
  }

  /// Gets eigenvalues and eigenvectors of this matrix
  ///
  /// Returns `Map` object that contains `values` and `vectors` keys with corresponding values.
  ///
  /// Uses [dart-data](https://pub.dartlang.org/packages/data) package of Lukas Renggli.
  Map<String, MatrixBase> eigenDecomposition() {
    final m = toMatrixDartData(this);
    final result = dd.eigenvalue(m);
    final eigenValues = fromMatrixDartData(result.D);
    final eigenVectors = fromMatrixDartData(result.V);
    return <String, MatrixBase>{'values': eigenValues, 'vectors': eigenVectors};
  }

  /// Performs Gaussian-Jordan elimination of this matrix and [equalTo] as right-side of augmented matrix
  ///
  /// [equalTo] should be equal to [rows].
  Vector eliminate(List<double> equalTo) {
    final eliminatedMatrix = SquareMatrix(data);
    final result = equalTo;

    for (var i = 1; i <= rows; i++) {
      if (eliminatedMatrix.itemAt(i, i) == 0) {
        final col = eliminatedMatrix.columnAt(i);
        final row = eliminatedMatrix.rowAt(i);

        final indexCol = row.indexWhere((n) => n != 0, i - 1);
        final indexRow = col.indexWhere((n) => n != 0, i - 1);

        if (indexRow != -1) {
          eliminatedMatrix.swapRows(i, indexRow + 1);

          final value = result[i - 1];
          result[i - 1] = result[indexRow];
          result[indexRow] = value;
        } else if (indexCol != -1) {
          eliminatedMatrix.swapColumns(i, indexCol + 1);
        }
      }

      final element = eliminatedMatrix.itemAt(i, i) == 0
          ? 1
          : eliminatedMatrix.itemAt(i, i);
      final choosedRow =
          eliminatedMatrix.rowAt(i).map((v) => v / element).toList();
      eliminatedMatrix.replaceRow(i, choosedRow);
      result[i - 1] /= element;

      for (var j = i + 1; j <= rows; j++) {
        final diff =
            eliminatedMatrix.itemAt(j, i) / eliminatedMatrix.itemAt(i, i);
        final tmpRow = Vector(choosedRow).transform((v) => v * -diff) +
            Vector(eliminatedMatrix.rowAt(j));

        result[j - 1] += result[i - 1] * -diff;
        eliminatedMatrix.replaceRow(j, tmpRow.data);
      }
    }

    for (var i = rows; i >= 1; i--) {
      final choosedRow = eliminatedMatrix.rowAt(i);

      for (var j = i - 1; j >= 1; j--) {
        final tmpRow = Vector(choosedRow)
                .transform((v) => v * -eliminatedMatrix.itemAt(j, i)) +
            Vector(eliminatedMatrix.columnAt(j));

        result[j - 1] += result[i - 1] * -eliminatedMatrix.itemAt(j, i);
        eliminatedMatrix.replaceRow(j, tmpRow.data);
      }
    }

    return Vector(result);
  }
}
