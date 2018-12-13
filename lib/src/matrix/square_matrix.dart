import 'dart:math';

import '../exceptions/matrix_exception.dart';
import 'matrix.dart';

/// Class for work with numeric square matrix
class SquareMatrix extends Matrix {
  /// Constructor accept array of arrays of double numbers
  ///
  /// Count of inner arrays must be equal to count of their elements!
  SquareMatrix(List<List<double>> data) : super(<List<double>>[]) {
    if (data.length != data[0].length) {
      throw MatrixException(
          'Count of inner arrays must be equal to count of their elements!');
    } else {
      this.data = data;
    }
  }

  /// Generate matrix with specified [number] of rows and columns
  ///
  /// If [fillRandom] is true, then matrix will filled with random numbers,
  /// otherwise matrix will have all values defaults to 0
  SquareMatrix.generate(int number, {bool fillRandom = false})
      : super.generate(number, number, fillRandom: fillRandom);

  /// Creates an identity matrix
  SquareMatrix.identity(int number) : super.identity(number, number);

  /// Gets determinant of matrix
  double getDeterminant() {
    final firstRow = rowAt(1);

    if (itemCount == 1) {
      return itemAt(0, 0);
    } else {
      double res = 0;
      for (var i = 0; i < firstRow.length; i++) {
        final changedMatrix =
            SquareMatrix(removeRow(1).removeColumn(i + 1).data);
        res +=
            pow(-1, 1 + (i + 1)) * firstRow[i] * changedMatrix.getDeterminant();
      }
      return res;
    }
  }

  /// Checks if this matrix is singular
  bool isSingular() => getDeterminant() == 0;

  /// Checks if this matrix is singular
  bool isNotSingular() => !isSingular();

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
          final det = SquareMatrix(nData).getDeterminant();
          matrixOfCofactors.setItem(i, j, pow(-1, i + j) * det);
        }
      }

      final adjugatedMatrix = SquareMatrix(matrixOfCofactors.transpose().data);
      final inversedMatrix = adjugatedMatrix.multiplyBy(1 / getDeterminant());
      return SquareMatrix(inversedMatrix.data);
    }
  }
}
