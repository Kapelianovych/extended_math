import 'dart:math';

import 'package:quiver/core.dart';

import '../../../../applied_mathematics/probability_theory/numbers_generator.dart';
import '../../../../applied_mathematics/statistic/central_tendency.dart';
import '../../../../general/elementary_algebra/unary_operations.dart';
import '../../../general_algebraic_systems/number/base/number.dart';
import '../../../general_algebraic_systems/number/exceptions/division_by_zero_exception.dart';
import '../../exceptions/matrix_exception.dart';
import '../../tensor/tensor1/vector.dart';
import '../base/tensor_base.dart';
import 'diagonal_matrix.dart';
import 'square_matrix.dart';

/// Class for work with numeric matrix
class Matrix extends TensorBase {
  /// Constructor accept array of arrays of num numbers
  const Matrix(this._data) : super(2);

  /// Generate matrix with specified [rows] and [cols]
  ///
  /// If [fillRandom] is true, then matrix will filled with random numbers,
  /// and if [fillRandom] is false and [identity] is true - creates an
  /// identity matrix, otherwise matrix will have all values defaults to 0.
  Matrix.generate(int rows, int cols,
      {bool fillRandom = false, bool identity = false})
      : _data = <List<num>>[],
        super(2) {
    if (fillRandom == true) {
      for (var j = 0; j < rows; j++) {
        _data.add(NumbersGenerator().doubleIterableSync().take(cols).toList());
      }
    } else {
      for (var i = 0; i < rows; i++) {
        final emptyRow = <num>[];
        for (var j = 0; j < cols; j++) {
          emptyRow.add(0);
        }

        if (identity == true && i < cols) {
          emptyRow[i] = 1;
        }

        _data.add(emptyRow);
      }
    }
  }

  /// Creates an identity matrix
  factory Matrix.identity(int rows, int cols) =>
      Matrix.generate(rows, cols, identity: true);

  /// Raw data of matrix
  final List<List<num>> _data;

  @override
  List<List<num>> get data => _data.map((r) => r.toList()).toList();

  @override
  List<int> get shape => [columns, rows];

  /// Rows count of matrix
  int get rows => data.length;

  /// Columns count of matrix
  int get columns => data[0].length;

  @override
  int get itemsCount => rows * columns;

  /// Gets number at specified [row] and [column]
  ///
  /// [row] and [column] are in range from 1 to end inclusively.
  num itemAt(int row, int column) => data[row - 1][column - 1];

  /// Set number to specified [value], replace old value if exist
  ///
  /// [row] and [column] are in range from 1 to end inclusively.
  void setItem(int row, int column, num value) =>
      _data[row - 1][column - 1] = value;

  /// Gets specified column in range from 1 to end inclusively.
  List<num> columnAt(int number) {
    final col = <num>[];

    for (final row in data) {
      col.add(row[number - 1]);
    }

    return col;
  }

  /// Gets specified row in range from 1 to end inclusively.
  List<num> rowAt(int number) => data[number - 1].toList();

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

  /// Multiply this matrix by another [matrix] using matrix product algorithm
  ///
  /// In order for the matrix `this` to be multiplied by the matrix [matrix],
  /// it is necessary that the number of columns of the matrix `this` be equal
  /// to the number of rows of the matrix [matrix].
  Matrix matrixProduct(Matrix matrix) {
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

  /// Multiply this matrix by another [matrix] by the Adamart (Schur) method
  ///
  /// Takes two matrices of the same dimensions and produces another matrix
  /// where each element `i`, `j` is the product of elements `i`, `j` of
  /// the original two matrices.
  Matrix hadamard(Matrix matrix) {
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

  /// Transpose matrix
  Matrix transpose() {
    final transposedMatrix = Matrix.generate(columns, rows);
    for (var i = 1; i <= rows; i++) {
      for (var j = 1; j <= columns; j++) {
        transposedMatrix.setItem(j, i, itemAt(i, j));
      }
    }
    return transposedMatrix;
  }

  /// Add [vector] to this matrix
  ///
  /// The [vector] is added to each row of this matrix.
  /// Columns of matrix should be equal to items count of vector.
  Matrix addVector(Vector vector) {
    if (columns == vector.itemsCount) {
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
  double frobeniusNorm() => norm(2);

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
  Matrix submatrix(int rowFrom, int rowTo, int colFrom, int colTo) {
    final newData = data
        .sublist(rowFrom - 1, rowTo)
        .map((row) => row.sublist(colFrom - 1, colTo))
        .toList();
    return Matrix(newData);
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

  /// Eliminates this matrix using elemantary operations
  ///
  /// Elimination will be done using Gaussian method.
  /// This matrix eliminates to upper triangle matrix.
  Matrix gaussian() {
    // Function checks for equaling values under main diagonal to zeroes
    bool isEliminatedByGaussian() {
      final minCount = min(rows, columns);

      for (var i = 1; i <= minCount; i++) {
        final allNull = columnAt(i).skip(i).every((n) => n == 0);
        if (!allNull) {
          return false;
        }
      }

      return true;
    }

    // Main code starts here
    final eliminatedMatrix = copy();

    for (var i = 1; i <= min(rows, columns); i++) {
      var nonNullCounts = 0;
      for (var row in eliminatedMatrix.data) {
        nonNullCounts += row.where((v) => v != 0).length;
      }
      final mainNonNullCounts =
          eliminatedMatrix.mainDiagonal().data.where((v) => v != 0).length;

      if (isEliminatedByGaussian() && nonNullCounts == mainNonNullCounts) {
        return eliminatedMatrix;
      }

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

        final tmpRow = Vector(choosedRow).map((v) => v * -diff) +
            Vector(eliminatedMatrix.rowAt(j));

        eliminatedMatrix.replaceRow(j, tmpRow.data);
      }
    }

    return eliminatedMatrix;
  }

  /// Gets specified column of matrix as vector
  Vector columnAsVector(int column) => Vector(columnAt(column));

  /// Gets specified row of matrix as vector
  Vector rowAsVector(int row) => Vector(rowAt(row));

  /// Calculates trace operator of this matrix
  num trace() {
    var sum = 0.0;
    for (final item in mainDiagonal().data) {
      sum += item;
    }
    return sum;
  }

  /// Gets rank of this matrix
  int rank() => gaussian().mainDiagonal().data.where((e) => e != 0).length;

  /// Singular value decomposition for this matrix.
  ///
  /// Singular-value decomposition (SVD) is a factorization of a real or
  /// complex matrix. It is the generalization of the eigendecomposition
  /// of a positive semidefinite normal matrix (for example, a symmetric
  /// matrix with positive eigenvalues) to any m×n matrix via an extension
  /// of the polar decomposition.
  ///
  /// Returns the matrices `E` (singular values), `U` (left-singular
  /// vectors) and `V` (right-singular vectors) with corresponding values.
  ///
  /// Created from [Jama's implemetation](https://github.com/fiji/Jama/blob/master/src/main/java/Jama/SingularValueDecomposition.java).
  (Matrix, Matrix, Matrix) svd() {
    // Row and column dimensions
    final m = rows;
    final n = columns;
    final nu = max(m, n);

    final a = data;

    // arrays for internal storage of u and V
    final u = Matrix.generate(m, nu).data;
    final v = SquareMatrix.generate(n).data;

    // array for internal storage of singular values
    final s = List<num>.filled(min(m + 1, n), 0);
    final e = List<num>.filled(n, 0);
    final work = List<num>.filled(m, 0);
    bool wantu = true;
    bool wantv = true;

    // Reduce a to bidiagonal form, storing the diagonal elements
    // in s and the super-diagonal elements in e.

    int nct = min(m - 1, n);
    int nrt = max(0, min(n - 2, m));
    for (int k = 0; k < max(nct, nrt); k++) {
      if (k < nct) {
        // Compute the transformation for the k-th column and
        // place the k-th diagonal in s[k].
        // Compute 2-norm of k-th column without under/overflow.
        s[k] = 0;
        for (int i = k; i < m; i++) {
          s[k] = hypot(s[k], a[i][k]);
        }
        if (s[k] != 0.0) {
          if (a[k][k] < 0.0) {
            s[k] = -s[k];
          }
          for (int i = k; i < m; i++) {
            a[i][k] /= s[k];
          }
          a[k][k] += 1.0;
        }
        s[k] = -s[k];
      }
      for (int j = k + 1; j < n; j++) {
        if ((k < nct) && (s[k] != 0.0)) {
          // apply the transformation.

          double t = 0;
          for (int i = k; i < m; i++) {
            t += a[i][k] * a[i][j];
          }
          t = -t / a[k][k];
          for (int i = k; i < m; i++) {
            a[i][j] += t * a[i][k];
          }
        }

        // Place the k-th row of a into e for the
        // subsequent calculation of the row transformation.

        e[j] = a[k][j];
      }
      if (wantu && (k < nct)) {
        // Place the transformation in U for subsequent back
        // multiplication.

        for (int i = k; i < m; i++) {
          u[i][k] = a[i][k];
        }
      }
      if (k < nrt) {
        // Compute the k-th row transformation and place the
        // k-th super-diagonal in e[k].
        // Compute 2-norm without under/overflow.
        e[k] = 0;
        for (int i = k + 1; i < n; i++) {
          e[k] = hypot(e[k], e[i]);
        }
        if (e[k] != 0.0) {
          if (e[k + 1] < 0.0) {
            e[k] = -e[k];
          }
          for (int i = k + 1; i < n; i++) {
            e[i] /= e[k];
          }
          e[k + 1] += 1.0;
        }
        e[k] = -e[k];
        if ((k + 1 < m) && (e[k] != 0.0)) {
          // apply the transformation.

          for (int i = k + 1; i < m; i++) {
            work[i] = 0.0;
          }
          for (int j = k + 1; j < n; j++) {
            for (int i = k + 1; i < m; i++) {
              work[i] += e[j] * a[i][j];
            }
          }
          for (int j = k + 1; j < n; j++) {
            double t = -e[j] / e[k + 1];
            for (int i = k + 1; i < m; i++) {
              a[i][j] += t * work[i];
            }
          }
        }
        if (wantv) {
          // Place the transformation in V for subsequent
          // back multiplication.

          for (int i = k + 1; i < n; i++) {
            v[i][k] = e[i];
          }
        }
      }
    }

    // Set up the final bidiagonal matrix or order p.

    int p = min(n, m + 1);
    if (nct < n) {
      s[nct] = a[nct][nct];
    }
    if (m < p) {
      s[p - 1] = 0.0;
    }
    if (nrt + 1 < p) {
      e[nrt] = a[nrt][p - 1];
    }
    e[p - 1] = 0.0;

    // If required, generate u.

    if (wantu) {
      for (int j = nct; j < nu; j++) {
        for (int i = 0; i < m; i++) {
          u[i][j] = 0.0;
        }
        u[j][j] = 1.0;
      }
      for (int k = nct - 1; k >= 0; k--) {
        if (s[k] != 0.0) {
          for (int j = k + 1; j < nu; j++) {
            double t = 0;
            for (int i = k; i < m; i++) {
              t += u[i][k] * u[i][j];
            }
            t = -t / u[k][k];
            for (int i = k; i < m; i++) {
              u[i][j] += t * u[i][k];
            }
          }
          for (int i = k; i < m; i++) {
            u[i][k] = -u[i][k];
          }
          u[k][k] = 1.0 + u[k][k];
          for (int i = 0; i < k - 1; i++) {
            u[i][k] = 0.0;
          }
        } else {
          for (int i = 0; i < m; i++) {
            u[i][k] = 0.0;
          }
          u[k][k] = 1.0;
        }
      }
    }

    // If required, generate V.

    if (wantv) {
      for (int k = n - 1; k >= 0; k--) {
        if ((k < nrt) && (e[k] != 0.0)) {
          for (int j = k + 1; j < nu; j++) {
            double t = 0;
            for (int i = k + 1; i < n; i++) {
              t += v[i][k] * v[i][j];
            }
            t = -t / v[k + 1][k];
            for (int i = k + 1; i < n; i++) {
              v[i][j] += t * v[i][k];
            }
          }
        }
        for (int i = 0; i < n; i++) {
          v[i][k] = 0.0;
        }
        v[k][k] = 1.0;
      }
    }

    // Main iteration loop for the singular values.

    int pp = p - 1;
    int iter = 0;
    double eps = pow(2.0, -52.0).toDouble();
    double tiny = pow(2.0, -966.0).toDouble();
    while (p > 0) {
      int k, kase;

      // Here is where a test for too many iterations would go.

      // This section of the program inspects for
      // negligible elements in the s and e arrays.  On
      // completion the variables kase and k are set as follows.

      // kase = 1     if s(p) and e[k-1] are negligible and k<p
      // kase = 2     if s(k) is negligible and k<p
      // kase = 3     if e[k-1] is negligible, k<p, and
      //              s(k), ..., s(p) are not negligible (qr step).
      // kase = 4     if e(p-1) is negligible (convergence).

      for (k = p - 2; k >= -1; k--) {
        if (k == -1) {
          break;
        }
        if (e[k].abs() <= tiny + eps * (s[k].abs() + s[k + 1]).abs()) {
          e[k] = 0.0;
          break;
        }
      }
      if (k == p - 2) {
        kase = 4;
      } else {
        int ks;
        for (ks = p - 1; ks >= k; ks--) {
          if (ks == k) {
            break;
          }
          num t = (ks != p ? e[ks].abs() : 0.0) +
              (ks != k + 1 ? e[ks - 1].abs() : 0.0);
          if (s[ks].abs() <= tiny + eps * t) {
            s[ks] = 0.0;
            break;
          }
        }
        if (ks == k) {
          kase = 3;
        } else if (ks == p - 1) {
          kase = 1;
        } else {
          kase = 2;
          k = ks;
        }
      }
      k++;

      // Perform the task indicated by kase.

      switch (kase) {

        // Deflate negligible s(p).

        case 1:
          {
            num f = e[p - 2];
            e[p - 2] = 0.0;
            for (int j = p - 2; j >= k; j--) {
              num t = hypot(s[j], f);
              double cs = s[j] / t;
              double sn = f / t;
              s[j] = t;
              if (j != k) {
                f = -sn * e[j - 1];
                e[j - 1] = cs * e[j - 1];
              }
              if (wantv) {
                for (int i = 0; i < n; i++) {
                  t = cs * v[i][j] + sn * v[i][p - 1];
                  v[i][p - 1] = -sn * v[i][j] + cs * v[i][p - 1];
                  v[i][j] = t;
                }
              }
            }
          }
          break;

        // Split at negligible s(k).

        case 2:
          {
            num f = e[k - 1];
            e[k - 1] = 0.0;
            for (int j = k; j < p; j++) {
              num t = hypot(s[j], f);
              double cs = s[j] / t;
              double sn = f / t;
              s[j] = t;
              f = -sn * e[j];
              e[j] = cs * e[j];
              if (wantu) {
                for (int i = 0; i < m; i++) {
                  t = cs * u[i][j] + sn * u[i][k - 1];
                  u[i][k - 1] = -sn * u[i][j] + cs * u[i][k - 1];
                  u[i][j] = t;
                }
              }
            }
          }
          break;

        // Perform one qr step.

        case 3:
          {
            // Calculate the shift.

            num scale = max(
                max(max(max(s[p - 1].abs(), s[p - 2].abs()), e[p - 2].abs()),
                    s[k].abs()),
                e[k].abs());
            double sp = s[p - 1] / scale;
            double spm1 = s[p - 2] / scale;
            double epm1 = e[p - 2] / scale;
            double sk = s[k] / scale;
            double ek = e[k] / scale;
            double b = ((spm1 + sp) * (spm1 - sp) + epm1 * epm1) / 2.0;
            double c = (sp * epm1) * (sp * epm1);
            double shift = 0.0;
            if ((b != 0.0) | (c != 0.0)) {
              shift = sqrt(b * b + c);
              if (b < 0.0) {
                shift = -shift;
              }
              shift = c / (b + shift);
            }
            double f = (sk + sp) * (sk - sp) + shift;
            double g = sk * ek;

            // Chase zeros.

            for (int j = k; j < p - 1; j++) {
              num t = hypot(f, g);
              double cs = f / t;
              double sn = g / t;
              if (j != k) {
                e[j - 1] = t;
              }
              f = cs * s[j] + sn * e[j];
              e[j] = cs * e[j] - sn * s[j];
              g = sn * s[j + 1];
              s[j + 1] = cs * s[j + 1];
              if (wantv) {
                for (int i = 0; i < n; i++) {
                  t = cs * v[i][j] + sn * v[i][j + 1];
                  v[i][j + 1] = -sn * v[i][j] + cs * v[i][j + 1];
                  v[i][j] = t;
                }
              }
              t = hypot(f, g);
              cs = f / t;
              sn = g / t;
              s[j] = t;
              f = cs * e[j] + sn * s[j + 1];
              s[j + 1] = -sn * e[j] + cs * s[j + 1];
              g = sn * e[j + 1];
              e[j + 1] = cs * e[j + 1];
              if (wantu && (j < m - 1)) {
                for (int i = 0; i < m; i++) {
                  t = cs * u[i][j] + sn * u[i][j + 1];
                  u[i][j + 1] = -sn * u[i][j] + cs * u[i][j + 1];
                  u[i][j] = t;
                }
              }
            }
            e[p - 2] = f;
            iter = iter + 1;
          }
          break;

        // Convergence.

        case 4:
          {
            // Make the singular values positive.

            if (s[k] <= 0.0) {
              s[k] = (s[k] < 0.0 ? -s[k] : 0.0);
              if (wantv) {
                for (int i = 0; i <= pp; i++) {
                  v[i][k] = -v[i][k];
                }
              }
            }

            // Order the singular values.

            while (k < pp) {
              if (s[k] >= s[k + 1]) {
                break;
              }
              num t = s[k];
              s[k] = s[k + 1];
              s[k + 1] = t;
              if (wantv && (k < n - 1)) {
                for (int i = 0; i < n; i++) {
                  t = v[i][k + 1];
                  v[i][k + 1] = v[i][k];
                  v[i][k] = t;
                }
              }
              if (wantu && (k < m - 1)) {
                for (int i = 0; i < m; i++) {
                  t = u[i][k + 1];
                  u[i][k + 1] = u[i][k];
                  u[i][k] = t;
                }
              }
              k++;
            }
            iter = 0;
            p--;
          }
          break;
      }
    }

    final sAsMatrix = SquareMatrix.generate(n).data;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        sAsMatrix[i][j] = 0.0;
      }
      sAsMatrix[i][i] = s[i];
    }
    return (
      Matrix(sAsMatrix), // E
      SquareMatrix(u), // U
      Matrix(v), // V
    );
  }

  /// Calculates QR decomposition of this matrix
  ///
  /// Returns `Map` with `Q` key points to **orthogonal matrix (Q)**
  /// and `R` key points to ** upper triangular matrix (R)**.
  /// Rows of matrix must be qreat or equal to columns, otherwise
  /// method returns `Map`, which keys point to `null`.
  Map<String, Matrix> qr() {
    final r = SquareMatrix.generate(columns);
    final q = Matrix.generate(rows, columns);
    final a = copy();

    if (rows >= columns) {
      for (var k = 1; k <= columns; k++) {
        var s = 0.0;
        for (var j = 1; j <= rows; j++) {
          s += pow(a.itemAt(j, k), 2);
        }
        r.setItem(k, k, sqrt(s));
        for (var j = 1; j <= rows; j++) {
          q.setItem(j, k, a.itemAt(j, k) / r.itemAt(k, k));
        }
        for (var i = k + 1; i <= columns; i++) {
          var ss = 0.0;
          for (var j = 1; j <= rows; j++) {
            ss += a.itemAt(j, i) * q.itemAt(j, k);
          }
          r.setItem(k, i, ss);
          for (var j = 1; j <= rows; j++) {
            a.setItem(j, i, a.itemAt(j, i) - r.itemAt(k, i) * q.itemAt(j, k));
          }
        }
      }
    }

    return <String, Matrix>{'Q': q, 'R': r};
  }

  /// Computes matrix norm
  ///
  /// Matrix norm is a vector norm in a vector space whose elements
  /// (vectors) are matrices (of given dimensions).
  ///
  /// If [q] is provided method computes `Lp,q norm`.
  double norm(int p, [int? q]) {
    final matrix = map((v) => pow(v.abs(), p));
    if (q == null) {
      return Number(matrix.reduce((f, s) => f + s)).rootOf(p).data;
    } else {
      var summ = Vector.generate(columns, (_) => 0);
      for (final item in matrix.data) {
        summ.insert(
            Number(pow(item.reduce((f, s) => f + s), q)).rootOf(p).data);
      }
      return Number(summ.reduce((f, s) => f + s)).rootOf(p).data;
    }
  }

  /// Computes infinity norm of this matrix
  ///
  /// Equal to [norm] with `p` equal to `Infinity`
  num infinityNorm() {
    num largest = 0;

    for (var i = 1; i <= rows; i++) {
      num sum = 0;
      for (var j = 1; j <= columns; j++) {
        sum += itemAt(i, j).abs(); // compute the row sum
      }
      if (sum > largest) {
        largest = sum; // found a new row sum
      }
    }

    return largest;
  }

  /// Computes spectral norm of this matrix
  num spectralNorm() {
    final (singularValues, _, _) = svd();
    return CentralTendency(singularValues).maximum();
  }

  /// Calculates the ratio `C` of the largest to smallest singular value in
  /// the singular value decomposition of a matrix
  double condition() {
    final (singularValues, _, _) = svd();
    final c = CentralTendency(singularValues);
    return c.maximum() / c.minimum();
  }

  /// add values of [other] to corresponding values of this matrix
  ///
  /// The matrices should be of the same dimension.
  @override
  Matrix operator +(Matrix other) {
    final newMatrix = Matrix.generate(rows, columns);
    for (var i = 1; i <= rows; i++) {
      for (var j = 1; j <= columns; j++) {
        newMatrix.setItem(i, j, itemAt(i, j) + other.itemAt(i, j));
      }
    }
    return newMatrix;
  }

  /// Subtract values of [other] from corresponding values of this matrix
  ///
  /// The matrices should be of the same dimension.
  @override
  Matrix operator -(Matrix other) => this + -other;

  @override
  Matrix operator -() => map((v) => -v);

  /// Multiply this matrix by [other]
  ///
  /// [other] may be one of three types:
  ///     1. num (and subclasses)
  ///     2. Matrix (and subclasses)
  ///     3. Number (and subclasses)
  ///
  /// Otherwise returns `null`.
  @override
  Matrix operator *(Object other) {
    var m = Matrix([]);
    if (other is num) {
      m = copy().map((v) => v * other);
    } else if (other is Matrix) {
      m = hadamard(other);
    } else if (other is Number) {
      m = copy().map((v) => v * other.data);
    }
    return m;
  }

  /// Divide this matrix by number of by [other] matrix
  /// if `this` matrix and [other] are square matrix.
  @override
  Matrix operator /(Object other) {
    var m = Matrix([]);
    if (other is num) {
      if (other == 0) {
        throw DivisionByZeroException();
      }
      m = this * (1 / other);
    } else if (this is SquareMatrix && other is SquareMatrix) {
      m = this * other.inverse();
    } else if (other is Number) {
      if (other.data == 0) {
        throw DivisionByZeroException();
      }
      m = this * (1 / other.data);
    }
    return m;
  }

  @override
  bool operator ==(Object other) =>
      other is Matrix && hashCode == other.hashCode;

  @override
  int get hashCode => hashObjects(data);

  @override
  Matrix map(num Function(num number) f) =>
      Matrix(data.map((row) => row.map(f).toList()).toList());

  @override
  num reduce(num Function(num prev, num next) f) {
    var list = <num>[];
    for (final row in data) {
      list = list.followedBy(row).toList();
    }
    return list.reduce(f);
  }

  @override
  bool every(bool Function(num number) f) {
    var list = <num>[];
    for (final row in data) {
      list = list.followedBy(row).toList();
    }
    return list.every(f);
  }

  @override
  bool any(bool Function(num number) f) {
    var list = <num>[];
    for (final row in data) {
      list = list.followedBy(row).toList();
    }
    return list.any(f);
  }

  @override
  List<num> toList() {
    var list = <num>[];
    for (final row in data) {
      list = list.followedBy(row).toList();
    }
    return list;
  }

  @override
  Matrix copy() => Matrix(data);

  @override
  String toString() => '$data';
}
