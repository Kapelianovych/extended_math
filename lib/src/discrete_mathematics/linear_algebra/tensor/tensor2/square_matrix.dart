import 'dart:math';

import 'package:data/matrix.dart' as dd;

import '../../../../utils/convert.dart';
import '../../exceptions/matrix_exception.dart';
import '../base/tensor_base.dart';
import '../tensor1/vector.dart';
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

  /// Creates an identity matrix with the specified [number] of rows/columns
  SquareMatrix.identity(int number) : this.generate(number, identity: true);

  /// Gets determinant of matrix
  num determinant() {
    final firstRow = rowAt(1);

    if (itemsCount == 1) {
      return itemAt(1, 1);
    } else {
      num res = 0;
      for (var i = 1; i <= columns; i++) {
        final changedMatrix = copy();
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

  /// Checks if this matrix is positive definite
  bool isPositiveDefinite() =>
      isSymmetric() && eigen().keys.every((k) => k > 0);

  /// Checks if this matrix is positive semi-definite
  bool isPositiveSemiDefinite() =>
      isSymmetric() && eigen().keys.every((k) => k >= 0);

  /// Checks if this matrix is negative definite
  bool isNegativeDefinite() =>
      isSymmetric() && eigen().keys.every((k) => k < 0);

  /// Checks if this matrix is negative semi-definite
  bool isNegativeSemiDefinite() =>
      isSymmetric() && eigen().keys.every((k) => k <= 0);

  /// Checks if this matrix is indefinite
  bool isIndefinite() {
    final eigValues = eigen().keys;
    return isSymmetric() &&
        eigValues.any((k) => k < 0) &&
        eigValues.any((k) => k > 0);
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

  /// Checks if this matrix is upper triangular
  bool isUpperTriangle() {
    for (var i = 1; i <= rows; i++) {
      final allNull = columnAt(i).skip(i).every((n) => n == 0);
      if (!allNull) {
        return false;
      }
    }

    return true;
  }

  /// Checks if this matrix is lower triangular
  bool isLowerTriangle() {
    for (var i = 1; i <= rows; i++) {
      final allNull = columnAt(i).take(i - 1).every((n) => n == 0);
      if (!allNull) {
        return false;
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
      final matrixOfCofactors = SquareMatrix.generate(rows);

      for (var i = 1; i <= rows; i++) {
        for (var j = 1; j <= columns; j++) {
          final origin = copy();
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
  /// Returns `Map` object where `Map.keys` are `eigenvalues` and `Map.values` are `eigenvectors`.
  ///
  /// Uses [dart-data](https://pub.dartlang.org/packages/data) package of Lukas Renggli.
  Map<num, Vector> eigen() {
    final thisCopy = copy().map((v) => v.toDouble());
    final m = toMatrixDartData(thisCopy);
    final ddResult = dd.eigenvalue(m);
    final eigenValues = fromMatrixDartData(ddResult.D).mainDiagonal();
    final eigenVectors = fromMatrixDartData(ddResult.V);

    final result = <num, Vector>{};
    for (var i = 1; i <= eigenValues.itemsCount; i++) {
      result[eigenValues.itemAt(i)] = eigenVectors.rowAsVector(i);
    }
    return result;
  }

  /// Calculates Cholesky decomposition of this `positive definite matrix`, otherwise returns `null`
  ///
  /// Returns only upper triangular matrix. To get second matrix `transpose` returned matrix.
  ///
  /// Uses [dart-data](https://pub.dartlang.org/packages/data) package of Lukas Renggli.
  SquareMatrix cholesky() {
    SquareMatrix m;
    if (isPositiveDefinite()) {
      final ddMatrix = toMatrixDartData(copy());
      final result = dd.cholesky(ddMatrix).L;
      m = fromMatrixDartData(result).toSquareMatrix();
    }
    return m;
  }

  /// Calculates LU decomposition of this matrix with partial pivoting
  ///
  /// Returns `Map` object where `upper` key contains **upper triangular matrix**,
  /// `lower` key contains **lower triangular matrix**, `pivote` key contains **permutation matrix**.
  Map<String, SquareMatrix> lu() {
    final thisCopy = copy();
    final lower = SquareMatrix.identity(rows);

    for (var c = 1; c < columns; c++) {
      for (var r = c + 1; r <= rows; r++) {
        final divide = thisCopy.itemAt(r, c) / thisCopy.itemAt(c, c);
        lower.setItem(r, c, divide);
        thisCopy.replaceRow(r,
            (thisCopy.rowAsVector(c) * -divide + thisCopy.rowAsVector(r)).data);
      }
    }

    final upper = gaussian().toSquareMatrix();
    final pivote = _pivotize();

    return <String, SquareMatrix>{
      'upper': upper,
      'lower': lower,
      'pivote': pivote
    };
  }

  /// Rearranging the rows of `A`, prior to the `LU` decomposition, in a way that the largest element of
  /// each column gets onto the diagonal of `A`
  SquareMatrix _pivotize() {
    final m = copy();
    final id = SquareMatrix.identity(m.rows);

    for (var i = 1; i <= m.rows; i++) {
      var maxm = m.itemAt(i, i);
      var row = i;

      for (var j = i; j < m.rows; j++) {
        if (m.itemAt(j, i) > maxm) {
          maxm = m.itemAt(j, i);
          row = j;
        }
      }

      if (i != row) {
        final tmp = id.rowAt(i);
        id..replaceRow(i, id.rowAt(row))..replaceRow(row, tmp);
      }
    }
    return id;
  }

  /// Performs Gaussian-Jordan elimination of this matrix and [equalTo] as right-side of augmented matrix
  ///
  /// [equalTo] should be equal to [rows].
  Vector eliminate(List<num> equalTo) {
    final eliminatedMatrix = copy();
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
        final tmpRow = Vector(choosedRow).map((v) => v * -diff) +
            Vector(eliminatedMatrix.rowAt(j));

        result[j - 1] += result[i - 1] * -diff;
        eliminatedMatrix.replaceRow(j, tmpRow.data);
      }
    }

    for (var i = rows; i >= 1; i--) {
      final choosedRow = eliminatedMatrix.rowAt(i);

      for (var j = i - 1; j >= 1; j--) {
        final tmpRow =
            Vector(choosedRow).map((v) => v * -eliminatedMatrix.itemAt(j, i)) +
                Vector(eliminatedMatrix.rowAt(j));

        result[j - 1] += result[i - 1] * -eliminatedMatrix.itemAt(j, i);
        eliminatedMatrix.replaceRow(j, tmpRow.data);
      }
    }

    return Vector(result);
  }

  @override
  SquareMatrix copy() => SquareMatrix(data);
}
