import 'package:data/matrix.dart' as dd;
import 'package:data/type.dart';

import '../discrete_mathematics/linear_algebra/matrix/base/matrix_base.dart';
import '../discrete_mathematics/linear_algebra/matrix/matrix.dart';

/// Converts matrix of `dart-data` library to matrix of this library
MatrixBase fromMatrixDartData(dd.Matrix<num> ddMatrix) {
  final m = Matrix.generate(ddMatrix.rowCount, ddMatrix.colCount);
  for (var r = 1; r <= ddMatrix.rowCount; r++) {
    for (var c = 1; c <= ddMatrix.colCount; c++) {
      m.setItem(r, c, ddMatrix.get(r - 1, c - 1));
    }
  }
  return m;
}

/// Converts matrix of this library to matrix of `dart-data` library
dd.Matrix<num> toMatrixDartData(MatrixBase matrix) {
  final m = dd.Matrix.builder
      .withType(DataType.numeric)
      .call(matrix.rows, matrix.columns);
  for (var r = 1; r <= matrix.rows; r++) {
    for (var c = 1; c <= matrix.columns; c++) {
      m.set(r - 1, c - 1, matrix.itemAt(r, c));
    }
  }
  return m;
}
