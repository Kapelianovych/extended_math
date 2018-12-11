import '../exceptions/matrix_exception.dart';
import '../vector/base/vector_base.dart';
import 'base/matrix_base.dart';

/// Class for work with numeric matrix
class Matrix extends MatrixBase {
  /// Constructor accept array of arrays of double numbers
  Matrix(List<List<double>> data) : super.init(data);

  /// Generate matrix with specified [rows] and [cols]
  ///
  /// If [fillRandom] is true, then matrix will filled with random numbers,
  /// otherwise matrix will have all values defaults to 0
  Matrix.generate(int rows, int cols, {bool fillRandom = false})
      : super.generate(rows, cols, fillRandom: fillRandom);

  /// Creates an identity matrix
  Matrix.identity(int rows, int cols)
      : super.generate(rows, cols, identity: true);

  @override
  int get rows => data.length;

  @override
  int get columns => data[0].length;

  @override
  int get itemCount => rows * columns;

  @override
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

  @override
  List<double> rowAt(int number) {
    if (number > rows) {
      throw RangeError('$number is out of range of matrix rows.');
    }
    return data[number - 1];
  }

  @override
  Matrix removeRow(int row) {
    if (row > rows) {
      throw RangeError('$row is out of range of matrix rows.');
    } else {
      final newData = List<List<double>>.of(data);
      newData.removeAt(row - 1);
      return Matrix(newData);
    }
  }

  @override
  Matrix removeColumn(int column) {
    if (column > columns) {
      throw RangeError('$column is out of range of matrix columns.');
    } else {
      final newData = <List<double>>[];

      for (var row in data) {
        final newRow = List<double>.of(row);
        newRow.removeAt(column - 1);
        newData.add(newRow);
      }
      return Matrix(newData);
    }
  }

  @override
  Matrix multiplyBy(double multiplier) {
    List<double> m(List<double> row) =>
        row.map((value) => value * multiplier).toList();
    return Matrix(data.map(m).toList());
  }

  @override
  Matrix multiplyByMatrix(MatrixBase matrix) {
    if (columns == matrix.rows) {
      return Matrix(data.map((row) {
        final result = <double>[];
        final resultTmp = <double>[];

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
  Matrix multiplyByVector(VectorBase vector) =>
      multiplyByMatrix(vector.toMatrix());

  @override
  Matrix hadamardProduct(MatrixBase matrix) {
    if (columns == matrix.columns && rows == matrix.rows) {
      final m = Matrix.generate(rows, columns);
      for (var i = 0; i < rows; i++) {
        for (var j = 0; j < columns; j++) {
          m.data[i][j] = data[i][j] * matrix.data[i][j];
        }
      }
      return m;
    } else {
      throw MatrixException('Multipied matrices doesn\'t match!');
    }
  }

  @override
  Matrix transform(double t(double v)) =>
      Matrix(data.map((row) => row.map(t).toList()).toList());

  @override
  Matrix transpose() {
    final transposedMatrix = Matrix.generate(columns, rows);
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        transposedMatrix.data[j][i] = data[i][j];
      }
    }
    return transposedMatrix;
  }

  @override
  Matrix subtract(MatrixBase matrix) {
    final subtractedMatrix = Matrix.generate(rows, columns);
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        subtractedMatrix.data[i][j] = data[i][j] - matrix.data[i][j];
      }
    }
    return subtractedMatrix;
  }

  @override
  Matrix add(MatrixBase matrix) {
    final newMatrix = Matrix.generate(rows, columns);
    for (var i = 0; i < rows; i++) {
      for (var j = 0; j < columns; j++) {
        newMatrix.data[i][j] = data[i][j] + matrix.data[i][j];
      }
    }
    return newMatrix;
  }

  @override
  Matrix addVector(VectorBase vector) {
    if (columns == vector.itemCount) {
      final newMatrix = Matrix.generate(rows, columns);
      for (var i = 0; i < rows; i++) {
        newMatrix.data[i] = vector.data;
      }
      return add(newMatrix);
    } else {
      throw MatrixException(
          'Columns of matrix should be equal to items count of vector!');
    }
  }
}
