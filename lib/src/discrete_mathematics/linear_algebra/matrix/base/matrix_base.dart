import 'dart:math';

import '../../../../applied_mathematics/probability_theory/numbers_generator.dart';
import '../../exceptions/matrix_exception.dart';
import '../../vector/base/vector_base.dart';
import '../../vector/vector.dart';
import '../diagonal_matrix.dart';
import '../square_matrix.dart';

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

      for (var j = 0; j < rows; j++) {
        data.add(
            NumbersGenerator().doubleSyncIterable(cols).take(cols).toList());
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
  MatrixBase multiplyByMatrix(covariant MatrixBase matrix);

  /// Multiply this matrix by [vector]
  MatrixBase multiplyByVector(covariant VectorBase vector);

  /// Multiply this matrix by another [matrix] by the Adamart (Schur) method
  ///
  /// Takes two matrices of the same dimensions and produces another matrix where each element
  ///  `i`, `j` is the product of elements `i`, `j` of the original two matrices.
  MatrixBase hadamardProduct(covariant MatrixBase matrix);

  /// Transform matrix with given [t] function
  MatrixBase transform(double t(double v));

  /// Transpose matrix
  MatrixBase transpose();

  /// Add [vector] to this matrix
  ///
  /// The [vector] is added to each row of this matrix.
  /// Columns of matrix should be equal to items count of vector.
  MatrixBase addVector(covariant VectorBase vector);

  /// Inserts row with given [newRow] to the end of matrix
  ///
  /// If [index] is specified, then [newRow] replace row at [index].
  /// [index] is in range from 1 to end of matrix including.
  MatrixBase insertRow(List<double> newRow, {int index});

  /// Inserts column with given [newColumn] to the end of matrix
  ///
  /// If [index] is specified, then [newColumn] replace column at [index].
  /// [index] is in range from 1 to end of matrix including.
  MatrixBase insertColumn(List<double> newColumn, {int index});

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

  /// Checks if this matrix is square
  bool isSquare() => rows == columns;

  /// Checks if this matrix is diagonal
  bool isDiagonal({bool checkIdentity = false}) {
    for (var r = 1; r <= rows; r++) {
      for (var c = 1; c <= columns; c++) {
        final rightExpression = itemAt(r, c) == 0 || r == c;

        if (checkIdentity) {
          if (!(itemAt(r, r) == 1 && rightExpression)) {
            return false;
          }
        } else {
          if (!(itemAt(r, r) != 0 && rightExpression)) {
            return false;
          }
        }
      }
    }
    return true;
  }

  /// Checks if this is identity matrix
  bool isIdentity() => isDiagonal(checkIdentity: true);

  /// Gets main diagonal of this matrix
  Vector mainDiagonal() {
    final data = <double>[];
    for (var i = 1; i <= rows; i++) {
      for (var j = 1; j <= columns; j++) {
        if (i == j) {
          data.add(itemAt(i, j));
        }
      }
    }
    return Vector(data);
  }

  /// Gets collateral diagonal of this matrix
  Vector collateralDiagonal() {
    final data = <double>[];
    var counter = columns;

    for (var i = 1; i <= rows; i++) {
      if (counter >= 1) {
        data.add(itemAt(i, counter));
        counter--;
      }
    }
    return Vector(data);
  }

  /// Converts this matrix to square matrix
  ///
  /// Throws `MatrixException` if [rows] isn't equal to [columns]
  SquareMatrix toSquareMatrix() => SquareMatrix(data);

  /// Converts this matrix to diagonal matrix
  DiagonalMatrix toDiagonalMatrix() {
    if (isDiagonal()) {
      return DiagonalMatrix(data);
    } else {
      throw MatrixException('This matrix isn\'t diagonal!');
    }
  }

  /// Gets specified row of matrix as vector
  VectorBase rowAsVector({int row = 1});

  /// Gets specified column of matrix as vector
  VectorBase columnAsVector({int column = 1});

  /// Gives the sum of all the diagonal entries of a matrix
  double trace() {
    var sum = 0.0;
    for (var item in mainDiagonal().data) {
      sum += item;
    }
    return sum;
  }

  /// Add values of [matrix] to corresponding values of this matrix
  ///
  /// The matrices should be of the same dimension
  MatrixBase operator +(covariant MatrixBase matrix);

  /// Subtract values of [matrix] from corresponding values of this matrix
  ///
  /// The matrices should be of the same dimension
  MatrixBase operator -(covariant MatrixBase matrix) =>
    this + matrix.transform((v) => -v);

  /// Multiply values of this matrix by corresponding values of [matrix]
  /// 
  /// Takes two matrices of the same dimensions and produces another matrix where each element
  /// `i`, `j` is the product of elements `i`, `j` of the original two matrices.
  MatrixBase operator *(covariant MatrixBase matrix) =>
    hadamardProduct(matrix);

  /// Multiply values of this matrix by corresponding values of [matrix]
  /// 
  /// Takes two matrices of the same dimensions and produces another matrix where each element
  /// `i`, `j` is the division's result of elements `i`, `j` of the original two matrices.
  MatrixBase operator /(covariant MatrixBase matrix) =>
    this * matrix.transform((v) => 1 / v);
}
