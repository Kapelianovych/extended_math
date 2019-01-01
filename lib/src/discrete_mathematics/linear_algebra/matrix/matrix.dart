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
  Matrix removeRow(int row) {
    if (row > rows) {
      throw RangeError('$row is out of range of matrix rows.');
    } else {
      final newData = List<List<num>>.of(data);
      newData.removeAt(row - 1);
      return Matrix(newData);
    }
  }

  @override
  Matrix removeColumn(int column) {
    if (column > columns) {
      throw RangeError('$column is out of range of matrix columns.');
    } else {
      final newData = <List<num>>[];

      for (var row in data) {
        final newRow = List<num>.of(row);
        newRow.removeAt(column - 1);
        newData.add(newRow);
      }
      return Matrix(newData);
    }
  }

  @override
  Matrix insertRow(List<num> newRow, {int index}) {
    if (newRow.length != columns) {
      throw MatrixException(
          'Needed $columns items in row, but found ${newRow.length}');
    } else if (index != null) {
      final newMatrix = Matrix(data);
      newMatrix.data[index - 1] = newRow;
      return newMatrix;
    } else {
      final newMatrix = Matrix(data);
      newMatrix.data.add(newRow);
      return newMatrix;
    }
  }

  @override
  Matrix insertColumn(List<num> newColumn, {int index}) {
    final newMatrix = Matrix(data);

    if (newColumn.length != rows) {
      throw MatrixException(
          'Needed $rows items in row, but found ${newColumn.length}');
    } else if (index != null) {
      for (var i = 1; i <= rows; i++) {
        newMatrix.setItem(i, index, newColumn[i - 1]);
      }
      return newMatrix;
    } else {
      for (var i = 1; i <= rows; i++) {
        newMatrix.data[i].add(newColumn[i - 1]);
      }
      return newMatrix;
    }
  }

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
  Vector columnAsVector({int column = 1}) => Vector(columnAt(column));

  @override
  Vector rowAsVector({int row = 1}) => Vector(rowAt(row));

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
