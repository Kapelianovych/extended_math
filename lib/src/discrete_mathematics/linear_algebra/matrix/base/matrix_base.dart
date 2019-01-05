import 'dart:math';

import 'package:quiver/core.dart';

import '../../../../applied_mathematics/probability_theory/numbers_generator.dart';
import '../../exceptions/matrix_exception.dart';
import '../../vector/base/vector_base.dart';
import '../../vector/vector.dart';
import '../diagonal_matrix.dart';
import '../matrix.dart';
import '../square_matrix.dart';

/// Base class for matrix
abstract class MatrixBase {
  /// Default constructor that don't accept [_data]
  MatrixBase();

  /// Constructor that accept [_data]
  MatrixBase.init(this._data);

  /// Generate matrix with specified [rows] and [cols]
  ///
  /// If [fillRandom] is true, then matrix will filled with random numbers,
  /// and if [fillRandom] is false and [identity] is true - creates an identity matrix,
  /// otherwise matrix will have all values defaults to 0
  MatrixBase.generate(int rows, int cols,
      {bool fillRandom = false, bool identity = false}) {
    if (fillRandom == true) {
      _data = <List<num>>[];

      for (var j = 0; j < rows; j++) {
        _data.add(
            NumbersGenerator().doubleIterableSync(cols).take(cols).toList());
      }
    } else {
      final emptyData = <List<num>>[];

      for (var i = 0; i < rows; i++) {
        final emptyRow = <num>[];
        for (var j = 0; j < cols; j++) {
          emptyRow.add(0);
        }

        if (identity == true && i < cols) {
          emptyRow[i] = 1;
        }

        emptyData.add(emptyRow);
      }
      _data = emptyData;
    }
  }

  /// Raw data of matrix
  List<List<num>> _data;

  /// Gets [_data] of this matrix
  List<List<num>> get data => _data.map((r) => r.toList()).toList();

  /// Rows count of matrix
  int get rows => _data.length;

  /// Columns count of matrix
  int get columns => _data[0].length;

  /// Count of all numbers of matrix
  int get itemCount => rows * columns;

  /// Gets number at specified [row] and [column]
  ///
  /// [row] and [column] are in range from 1 to end inclusively.
  num itemAt(int row, int column) => _data[row - 1][column - 1];

  /// Set number to specified [value], replace old value if exist
  ///
  /// [row] and [column] are in range from 1 to end inclusively.
  void setItem(int row, int column, num value) =>
      _data[row - 1][column - 1] = value;

  /// Gets specified column in range from 1 to end inclusively.
  List<num> columnAt(int number) {
    final col = <num>[];

    for (var row in _data) {
      col.add(row[number - 1]);
    }

    return col;
  }

  /// Gets specified row in range from 1 to end inclusively.
  List<num> rowAt(int number) => _data[number - 1].toList();

  /// Removes specified row
  ///
  /// [row] sould be in range from 1 to end inclusively.
  List<num> removeRow(int row) => _data.removeAt(row - 1);

  /// Removes specified column
  ///
  /// [column] sould be in range from 1 to end inclusively.
  List<num> removeColumn(int column) {
    final removedColumn = <num>[];
    for (var i = 1; i <= rows; i++) {
      removedColumn.add(_data[i - 1].removeAt(column - 1));
    }
    return removedColumn;
  }

  /// Multiply matrix by number
  MatrixBase _multiplyBy(num multiplier) {
    List<num> m(List<num> row) =>
        row.map((value) => value * multiplier).toList();
    return Matrix(_data.map(m).toList());
  }

  /// Multiply this matrix by another [matrix]
  ///
  /// In order for the matrix `this` to be multiplied by the matrix [matrix], it is necessary
  /// that the number of columns of the matrix `this` be equal to the number of rows of the matrix [matrix].
  MatrixBase multiplyByMatrix(covariant MatrixBase matrix);

  /// Multiply this matrix by another [matrix] by the Adamart (Schur) method
  ///
  /// Takes two matrices of the same dimensions and produces another matrix where each element
  ///  `i`, `j` is the product of elements `i`, `j` of the original two matrices.
  MatrixBase hadamardProduct(covariant MatrixBase matrix);

  /// Transform matrix with given [t] function
  MatrixBase transform(num t(num v));

  /// Transpose matrix
  MatrixBase transpose();

  /// Add [vector] to this matrix
  ///
  /// The [vector] is added to each row of this matrix.
  /// Columns of matrix should be equal to items count of vector.
  MatrixBase addVector(covariant VectorBase vector);

  /// Replaces row with given [newRow] at the specified [index]
  ///
  /// [index] is in range from 1 to end of matrix including.
  void replaceRow(int index, List<num> newRow) {
    if (newRow.length != columns) {
      throw MatrixException(
          'Needed $columns items in row, but found ${newRow.length}');
    }
    _data[index - 1] = newRow;
  }

  /// Replaces column with given [newColumn] at the specified [index]
  ///
  /// [index] is in range from 1 to end of matrix including.
  void replaceColumn(int index, List<num> newColumn) {
    if (newColumn.length != rows) {
      throw MatrixException(
          'Needed $rows items in row, but found ${newColumn.length}');
    }

    for (var i = 1; i <= rows; i++) {
      setItem(i, index, newColumn[i - 1]);
    }
  }

  /// Appends [row] to the end of this matrix
  void appendRow(List<num> row) {
    if (row.length != columns) {
      throw MatrixException(
          'Needed $columns items in row, but found ${row.length}');
    }

    _data.add(row);
  }

  /// Appends [column] to the end of this matrix
  void appendColumn(List<num> column) {
    if (column.length != rows) {
      throw MatrixException(
          'Needed $rows items in row, but found ${column.length}');
    }

    for (var i = 1; i <= rows; i++) {
      _data[i - 1].add(column[i - 1]);
    }
  }

  /// Swaps two rows
  ///
  /// [from] and [to] are in range from 1 to end inclusively.
  void swapRows(int from, int to) {
    final toRow = rowAt(to);
    final fromRow = rowAt(from);
    replaceRow(from, toRow);
    replaceRow(to, fromRow);
  }

  /// Swaps two columns
  ///
  /// [from] and [to] are in range from 1 to end inclusively.
  void swapColumns(int from, int to) {
    final toColumn = columnAt(to);
    final fromColumn = columnAt(from);
    replaceColumn(from, toColumn);
    replaceColumn(to, fromColumn);
  }

  /// Gets Frobenius norm of matrix
  num frobeniusNorm() {
    var sum = 0.0;
    for (var row in _data) {
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

  /// Checks if this matrix is eliminated by Gaussian method
  bool isUpperTriangle() {
    final minCount = min(rows, columns);

    for (var i = 1; i <= minCount; i++) {
      final allNull = columnAt(i).skip(i).every((n) => n == 0);
      if (!allNull) {
        return false;
      }
    }

    return true;
  }

  /// Gets main diagonal of this matrix
  Vector mainDiagonal() {
    final data = <num>[];
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
    final data = <num>[];
    var counter = columns;

    for (var i = 1; i <= rows; i++) {
      if (counter >= 1) {
        data.add(itemAt(i, counter));
        counter--;
      }
    }
    return Vector(data);
  }

  /// Gets submatrix of this matrix
  ///
  /// All parameters may be in range from 1 to end of matrix inclusively.
  MatrixBase submatrix(int rowFrom, int rowTo, int colFrom, int colTo);

  /// Converts this matrix to square matrix
  ///
  /// Throws `MatrixException` if [rows] isn't equal to [columns]
  SquareMatrix toSquareMatrix() => SquareMatrix(_data);

  /// Converts this matrix to diagonal matrix
  DiagonalMatrix toDiagonalMatrix() {
    if (isDiagonal()) {
      return DiagonalMatrix(_data);
    } else {
      throw MatrixException('This matrix isn\'t diagonal!');
    }
  }

  /// Gets specified row of matrix as vector
  VectorBase rowAsVector(int row);

  /// Gets specified column of matrix as vector
  VectorBase columnAsVector(int column);

  /// Gives the sum of all the diagonal entries of a matrix
  num trace() {
    var sum = 0.0;
    for (var item in mainDiagonal().data) {
      sum += item;
    }
    return sum;
  }

  /// Eliminates this matrix using elemantary operations
  ///
  /// Elimination will be done using Gaussian method.
  /// This matrix eliminates to upper triangle matrix.
  MatrixBase gaussian();

  /// Gets rang of this matrix
  int rank() => gaussian().mainDiagonal().data.where((e) => e != 0).length;

  /// Add values of [matrix] to corresponding values of this matrix
  ///
  /// The matrices should be of the same dimension
  MatrixBase operator +(covariant MatrixBase matrix);

  /// Subtract values of [matrix] from corresponding values of this matrix
  ///
  /// The matrices should be of the same dimension
  MatrixBase operator -(covariant MatrixBase matrix) => this + -matrix;

  /// Unary minus of this matrix
  MatrixBase operator -() => transform((v) => -v);

  /// Multiply this matrix by [other]
  ///
  /// [other] may be one of two types:
  ///     1. num (and subclasses)
  ///     2. MatrixBase (and subclasses)
  ///
  /// Otherwise returns `null`.
  MatrixBase operator *(Object other) {
    MatrixBase m;
    if (other is num) {
      m = _multiplyBy(other);
    } else if (other is MatrixBase) {
      m = hadamardProduct(other);
    }
    return m;
  }

  /// Divide this matrix by number of by [other] matrix
  /// if `this` matrix and [other] are square matrix.
  MatrixBase operator /(Object other) {
    MatrixBase m;
    if (other is num) {
      m = this * 1 / other;
    } else if (this is SquareMatrix && other is SquareMatrix) {
      m = this * other.inverse();
    }
    return m;
  }

  @override
  bool operator ==(Object other) =>
      other is MatrixBase && hashCode == other.hashCode;

  @override
  int get hashCode => hashObjects(_data);

  @override
  String toString() => '$_data';
}
