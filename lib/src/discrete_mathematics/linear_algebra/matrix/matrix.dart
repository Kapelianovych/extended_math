import 'dart:math';

import '../exceptions/matrix_exception.dart';
import '../vector/vector.dart';
import 'base/matrix_base.dart';

/// Class for work with numeric matrix
class Matrix extends MatrixBase {
  /// Constructor accept array of arrays of num numbers
  Matrix(List<List<num>> data) : super.init(data);

  /// Generate matrix with specified [rows] and [cols]
  ///
  /// If [fillRandom] is true, then matrix will filled with random numbers,
  /// otherwise matrix will have all values defaults to 0
  Matrix.generate(int rows, int cols,
      {bool fillRandom = false, bool identity = false})
      : super.generate(rows, cols, fillRandom: fillRandom, identity: identity);

  /// Creates an identity matrix
  Matrix.identity(int rows, int cols)
      : super.generate(rows, cols, identity: true);

  @override
  Matrix multiplyByMatrix(Matrix matrix) {
    if (columns == matrix.rows) {
      return Matrix(data.map((row) {
        final result = <num>[];
        final resultTmp = <num>[];

        for (var i = 1; i <= matrix.columns; i++) {
          final mCol = matrix.columnAt(i);
          resultTmp.clear();

          for (var j = 0; j < columns; j++) {
            resultTmp.add(row[j] * mCol[j]);
          }

          result.add(resultTmp.reduce((f, s) => f + s));
        }

        return result;
      }).toList());
    } else {
      throw MatrixException(
          'Columns of first matrix don\'t match rows of second!');
    }
  }

  @override
  Matrix hadamardProduct(Matrix matrix) {
    if (columns == matrix.columns && rows == matrix.rows) {
      final m = Matrix.generate(rows, columns);
      for (var i = 1; i <= rows; i++) {
        for (var j = 1; j <= columns; j++) {
          m.setItem(i, j, itemAt(i, j) * matrix.itemAt(i, j));
        }
      }
      return m;
    } else {
      throw MatrixException('Multipied matrices doesn\'t match!');
    }
  }

  @override
  Matrix transform(num t(num v)) =>
      Matrix(data.map((row) => row.map(t).toList()).toList());

  @override
  Matrix transpose() {
    final transposedMatrix = Matrix.generate(columns, rows);
    for (var i = 1; i <= rows; i++) {
      for (var j = 1; j <= columns; j++) {
        transposedMatrix.setItem(j, i, itemAt(i, j));
      }
    }
    return transposedMatrix;
  }

  @override
  Matrix addVector(Vector vector) {
    if (columns == vector.itemCount) {
      final newMatrix = Matrix.generate(rows, columns);
      for (var r = 1; r <= rows; r++) {
        for (var c = 1; c <= columns; c++) {
          newMatrix.setItem(r, c, itemAt(r, c) + vector.itemAt(c));
        }
      }
      return this + newMatrix;
    } else {
      throw MatrixException(
          'Columns of matrix should be equal to items count of vector!');
    }
  }

  @override
  Matrix submatrix(int rowFrom, int rowTo, int colFrom, int colTo) {
    final newData = data
        .sublist(rowFrom - 1, rowTo)
        .map((row) => row.sublist(colFrom - 1, colTo))
        .toList();
    return Matrix(newData);
  }

  @override
  Matrix gaussian() {
    if (isUpperTriangle()) {
      return this;
    }

    final eliminatedMatrix = Matrix(data);

    for (var i = 1; i <= min(rows, columns); i++) {
      if (eliminatedMatrix.itemAt(i, i) == 0) {
        final col = eliminatedMatrix.columnAt(i);
        final row = eliminatedMatrix.rowAt(i);

        final indexCol = row.indexWhere((n) => n != 0, i - 1);
        final indexRow = col.indexWhere((n) => n != 0, i - 1);

        if (indexRow != -1) {
          eliminatedMatrix.swapRows(i, indexRow + 1);
        } else if (indexCol != -1) {
          eliminatedMatrix.swapColumns(i, indexCol + 1);
        }
      }

      final choosedRow = eliminatedMatrix.rowAt(i);

      for (var j = i + 1; j <= rows; j++) {
        // For avoiding NaN if main diagonal contains mostly with 0
        if (eliminatedMatrix.itemAt(i, i) == 0) {
          continue;
        }

        final diff =
            eliminatedMatrix.itemAt(j, i) / eliminatedMatrix.itemAt(i, i);
        print(diff);
        final tmpRow = Vector(choosedRow).transform((v) => v * -diff) +
            Vector(eliminatedMatrix.rowAt(j));

        eliminatedMatrix.replaceRow(j, tmpRow.data);
      }
    }

    return eliminatedMatrix;
  }

  @override
  Vector columnAsVector(int column) => Vector(columnAt(column));

  @override
  Vector rowAsVector(int row) => Vector(rowAt(row));

  @override
  Matrix operator +(Matrix matrix) {
    final newMatrix = Matrix.generate(rows, columns);
    for (var i = 1; i <= rows; i++) {
      for (var j = 1; j <= columns; j++) {
        newMatrix.setItem(i, j, itemAt(i, j) + matrix.itemAt(i, j));
      }
    }
    return newMatrix;
  }
}
