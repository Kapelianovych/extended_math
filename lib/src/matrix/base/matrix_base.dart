import 'dart:math';

import '../../vector/base/vector_base.dart';

/// Base class for matrix
abstract class MatrixBase {
  /// Default constructor that don't accept [data]
  MatrixBase();

  /// Constructor that accept [data]
  MatrixBase.init(this.data);

  /// Generate matrix with specified [rows] and [cols]
  ///
  /// If [fillRandom] is true, then matrix will filled with random numbers,
  /// and if [fillRandom] is false and [identity] is true - creates an identity matrix,
  /// otherwise matrix will have all values defaults to 0
  MatrixBase.generate(int rows, int cols,
      {bool fillRandom = false, bool identity = false}) {
    if (fillRandom == true) {
      data = <List<double>>[];

      Iterable<double> genNumbers(int count) sync* {
        var i = 0;
        while (i < count) {
          i++;
          yield Random().nextDouble();
        }
      }

      for (var j = 0; j < rows; j++) {
        data.add(genNumbers(cols).take(cols).toList());
      }
    } else {
      final emptyData = <List<double>>[];

      for (var i = 0; i < rows; i++) {
        final emptyRow = <double>[];
        for (var j = 0; j < cols; j++) {
          emptyRow.add(0);
        }

        if (identity == true && i < cols) {
          emptyRow[i] = 1;
        }

        emptyData.add(emptyRow);
      }
      data = emptyData;
    }
  }

  /// Raw data of matrix
  List<List<double>> data;

  /// Rows count of matrix
  int get rows => data.length;

  /// Columns count of matrix
  int get columns => data[0].length;

  /// Count of all numbers of matrix
  int get itemCount => rows * columns;

  /// Gets number at specified [row] and [column]
  ///
  /// [row] and [column] are in range from 1 to end inclusively.
  double itemAt(int row, int column) {
    if (row > rows || column > columns) {
      throw RangeError(
          '$row or $column is out of range of matrix rows/columns.');
    } else {
      return data[row - 1][column - 1];
    }
  }

  /// Set number to specified [value], replace old value if exist
  ///
  /// [row] and [column] are in range from 1 to end inclusively.
  void setItem(int row, int column, double value) {
    if (row > rows || column > columns) {
      throw RangeError(
          '$row or $column is out of range of matrix rows/columns.');
    } else {
      data[row - 1][column - 1] = value;
    }
  }

  /// Gets specified column in range from 1 to end
  List<double> columnAt(int number) {
    final col = <double>[];

    if (number > columns) {
      throw RangeError('$number is out of range of matrix columns.');
    }

    for (var row in data) {
      col.add(row[number - 1]);
    }

    return col;
  }

  /// Gets specified row in range from 1 to end
  List<double> rowAt(int number) {
    if (number > rows) {
      throw RangeError('$number is out of range of matrix rows.');
    }
    return data[number - 1];
  }

  /// Removes specified row
  MatrixBase removeRow(int row);

  /// Removes specified column
  MatrixBase removeColumn(int column);

  /// Multiply matrix by number
  MatrixBase multiplyBy(double multiplier);

  /// Multiply this matrix by another [matrix]
  ///
  /// In order for the matrix `this` to be multiplied by the matrix [matrix], it is necessary
  /// that the number of columns of the matrix `this` be equal to the number of rows of the matrix [matrix].
  MatrixBase multiplyByMatrix(MatrixBase matrix);

  /// Multiply this matrix by [vector]
  MatrixBase multiplyByVector(VectorBase vector);

  /// Multiply this matrix by another [matrix] by the Adamart (Schur) method
  ///
  /// Takes two matrices of the same dimensions and produces another matrix where each element
  ///  `i`, `j` is the product of elements `i`, `j` of the original two matrices.
  MatrixBase hadamardProduct(MatrixBase matrix);

  /// Transform matrix with given [t] function
  MatrixBase transform(double t(double v));

  /// Transpose matrix
  MatrixBase transpose();

  /// Take away one [matrix] from this
  ///
  /// The matrices should be of the same dimension
  MatrixBase subtract(MatrixBase matrix);

  /// Add one [matrix] to this
  ///
  /// The matrices should be of the same dimension
  MatrixBase add(MatrixBase matrix);

  /// Add [vector] to this matrix
  ///
  /// The [vector] is added to each row of this matrix.
  /// Columns of matrix should be equal to items count of vector.
  MatrixBase addVector(VectorBase vector);

  /// Checks if this is identity matrix
  bool isIdentity() {
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        if (!(itemAt(i, i) == 1 && (itemAt(i, j) == 0 || i == j))) {
          return false;
        }
      }
    }
    return true;
  }

  /// Replace row at [index] with given [newRow]
  ///
  /// [index] is in range from 1 to end of matrix including.
  MatrixBase replaceRow(int index, List<double> newRow);

  /// Replace row at [index] with given [newColumn]
  ///
  /// [index] is in range from 1 to end of matrix including.
  MatrixBase replaceColumn(int index, List<double> newColumn);

  /// Gets Frobenius norm of matrix
  double frobeniusNorm() {
    var sum = 0.0;
    for (var row in data) {
      for (var val in row) {
        sum += pow(val, 2);
      }
    }
    return sqrt(sum);
  }
}
