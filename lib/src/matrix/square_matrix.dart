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

  /// Creates an identity matrix
  SquareMatrix.identity(int number) : super.identity(number, number);

  /// Gets determinant of matrix
  double getDeterminant() {
    final firstRow = rowAt(1);

    if (itemCount == 4) {
      return data[0][0] * data[1][1] - data[0][1] * data[1][0];
    } else {
      double res = 0;
      for (var number in firstRow) {
        final index = firstRow.indexOf(number);
        final changedMatrix =
            SquareMatrix(removeRow(1).removeColumn(index + 1).data);

        res += pow(-1, index) * number * changedMatrix.getDeterminant();
      }
      return res;
    }
  }

  // /// Inverse and return inversed matrix
  // SquareMatrix inverse() {
  //   if (getDeterminant() == 0) {
  //     throw MatrixException('The inverse is impossible because determinant of matrix equal to zero!');
  //   } else {

  //   }
  // }
}
