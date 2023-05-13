import 'dart:math';

import '../../../../general/elementary_algebra/unary_operations.dart';
import '../../exceptions/matrix_exception.dart';
import '../tensor1/vector.dart';
import 'matrix.dart';

/// Class for work with numeric square matrix
class SquareMatrix extends Matrix {
  /// Constructor accept array of arrays of num numbers
  ///
  /// Count of inner arrays must be equal to count of their elements!
  SquareMatrix(List<List<num>> data) : super(data) {
    if (data.length != data[0].length) {
      throw MatrixException(
          'Count of matrix columns must be equal to count of rows!');
    }
  }

  /// Generate matrix with specified [number] of rows and columns
  ///
  /// If [fillRandom] is true, then matrix will filled with random numbers,
  /// otherwise matrix will have all values defaults to 0
  SquareMatrix.generate(int number,
      {bool fillRandom = false, bool identity = false})
      : super.generate(number, number,
            fillRandom: fillRandom, identity: identity);

  /// Creates an identity matrix with the specified [number] of rows/columns
  SquareMatrix.identity(int number) : this.generate(number, identity: true);

  /// Gets determinant of matrix
  num determinant() {
    final firstRow = rowAt(1);

    if (itemsCount == 1) {
      return itemAt(1, 1);
    } else {
      num res = 0;
      for (var i = 1; i <= columns; i++) {
        final changedMatrix = copy();
        changedMatrix
          ..removeRow(1)
          ..removeColumn(i);
        res += pow(-1, 1 + i) * firstRow[i - 1] * changedMatrix.determinant();
      }
      return res;
    }
  }

  /// Checks if this matrix is singular
  bool isSingular() => determinant() == 0;

  /// Checks if this matrix isn't singular
  bool isNotSingular() => !isSingular();

  /// Checks if this matrix is symmetric
  bool isSymmetric() {
    for (var r = 1; r <= rows; r++) {
      for (var c = 1; c <= columns; c++) {
        if (itemAt(r, c) != itemAt(c, r)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if this matrix is positive definite
  bool isPositiveDefinite() =>
      isSymmetric() && eigen().keys.every((k) => k > 0);

  /// Checks if this matrix is positive semi-definite
  bool isPositiveSemiDefinite() =>
      isSymmetric() && eigen().keys.every((k) => k >= 0);

  /// Checks if this matrix is negative definite
  bool isNegativeDefinite() =>
      isSymmetric() && eigen().keys.every((k) => k < 0);

  /// Checks if this matrix is negative semi-definite
  bool isNegativeSemiDefinite() =>
      isSymmetric() && eigen().keys.every((k) => k <= 0);

  /// Checks if this matrix is indefinite
  bool isIndefinite() {
    final eigValues = eigen().keys;
    return isSymmetric() &&
        eigValues.any((k) => k < 0) &&
        eigValues.any((k) => k > 0);
  }

  /// Checks if this matrix is orthogonal
  bool isOrthogonal() {
    final inversed = inverse();
    final transposed = transpose();

    for (var i = 1; i <= rows; i++) {
      for (var j = 1; j <= columns; j++) {
        if (inversed.itemAt(i, j) != transposed.itemAt(i, j)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if this matrix is upper triangular
  bool isUpperTriangle() {
    for (var i = 1; i <= rows; i++) {
      final allNull = columnAt(i).skip(i).every((n) => n == 0);
      if (!allNull) {
        return false;
      }
    }

    return true;
  }

  /// Checks if this matrix is lower triangular
  bool isLowerTriangle() {
    for (var i = 1; i <= rows; i++) {
      final allNull = columnAt(i).take(i - 1).every((n) => n == 0);
      if (!allNull) {
        return false;
      }
    }

    return true;
  }

  /// Inverse and return inversed matrix
  SquareMatrix inverse() {
    if (isSingular()) {
      throw MatrixException('The inverse is impossible because determinant '
          'of matrix equal to zero!');
    } else {
      final matrixOfCofactors = SquareMatrix.generate(rows);

      for (var i = 1; i <= rows; i++) {
        for (var j = 1; j <= columns; j++) {
          final origin = copy();
          origin
            ..removeRow(i)
            ..removeColumn(j);
          final det = origin.determinant();
          matrixOfCofactors.setItem(i, j, pow(-1, i + j) * det);
        }
      }

      final adjugatedMatrix = SquareMatrix(matrixOfCofactors.transpose().data);
      final inversedMatrix = adjugatedMatrix * (1 / determinant());
      return SquareMatrix(inversedMatrix.data);
    }
  }

  /// Gets eigenvalues and eigenvectors of this matrix
  ///
  /// Returns `Map` object where `Map.keys` are `eigenvalues` and
  /// `Map.values` are `eigenvectors`.
  ///
  /// Created from [Jama's implemetation](https://github.com/fiji/Jama/blob/master/src/main/java/Jama/EigenvalueDecomposition.java).
  Map<num, Vector> eigen() {
    /* ------------------------
   Class variables
 * ------------------------ */

    /** Row and column dimension (square matrix).
   @serial matrix dimension.
   */
    int n = columns;

    /** Symmetry flag.
   @serial internal symmetry flag.
   */
    bool issymmetric;

    /** Arrays for internal storage of eigenvalues.
   @serial internal storage of eigenvalues.
   */
    List<double> d = List<double>.filled(n, 0), e = List<double>.filled(n, 0);

    /** Array for internal storage of eigenvectors.
   @serial internal storage of eigenvectors.
   */
    List<List<double>> V = [];

    /** Array for internal storage of nonsymmetric Hessenberg form.
   @serial internal storage of nonsymmetric Hessenberg form.
   */
    List<List<double>> H = [];

    /** Working storage for nonsymmetric algorithm.
   @serial working storage for nonsymmetric algorithm.
   */
    List<double> ort = List<double>.filled(n, 0.0);

    for (var i = 0; i < n; i++) {
      V.add(List<double>.filled(n, 0.0));
      H.add(List<double>.filled(n, 0.0));
    }

/* ------------------------
   Private Methods
 * ------------------------ */

    // Symmetric Householder reduction to tridiagonal form.

    void tred2() {
      //  This is derived from the Algol procedures tred2 by
      //  Bowdler, Martin, Reinsch, and Wilkinson, Handbook for
      //  Auto. Comp., Vol.ii-Linear Algebra, and the corresponding
      //  Fortran subroutine in EISPACK.

      for (int j = 0; j < n; j++) {
        d[j] = V[n - 1][j];
      }

      // Householder reduction to tridiagonal form.

      for (int i = n - 1; i > 0; i--) {
        // Scale to avoid under/overflow.

        double scale = 0.0;
        double h = 0.0;
        for (int k = 0; k < i; k++) {
          scale = scale + d[k].abs();
        }
        if (scale == 0.0) {
          e[i] = d[i - 1];
          for (int j = 0; j < i; j++) {
            d[j] = V[i - 1][j];
            V[i][j] = 0.0;
            V[j][i] = 0.0;
          }
        } else {
          // Generate Householder vector.

          for (int k = 0; k < i; k++) {
            d[k] /= scale;
            h += d[k] * d[k];
          }
          double f = d[i - 1];
          double g = sqrt(h);
          if (f > 0) {
            g = -g;
          }
          e[i] = scale * g;
          h = h - f * g;
          d[i - 1] = f - g;
          for (int j = 0; j < i; j++) {
            e[j] = 0.0;
          }

          // Apply similarity transformation to remaining columns.

          for (int j = 0; j < i; j++) {
            f = d[j];
            V[j][i] = f;
            g = e[j] + V[j][j] * f;
            for (int k = j + 1; k <= i - 1; k++) {
              g += V[k][j] * d[k];
              e[k] += V[k][j] * f;
            }
            e[j] = g;
          }
          f = 0.0;
          for (int j = 0; j < i; j++) {
            e[j] /= h;
            f += e[j] * d[j];
          }
          double hh = f / (h + h);
          for (int j = 0; j < i; j++) {
            e[j] -= hh * d[j];
          }
          for (int j = 0; j < i; j++) {
            f = d[j];
            g = e[j];
            for (int k = j; k <= i - 1; k++) {
              V[k][j] -= (f * e[k] + g * d[k]);
            }
            d[j] = V[i - 1][j];
            V[i][j] = 0.0;
          }
        }
        d[i] = h;
      }

      // Accumulate transformations.

      for (int i = 0; i < n - 1; i++) {
        V[n - 1][i] = V[i][i];
        V[i][i] = 1.0;
        double h = d[i + 1];
        if (h != 0.0) {
          for (int k = 0; k <= i; k++) {
            d[k] = V[k][i + 1] / h;
          }
          for (int j = 0; j <= i; j++) {
            double g = 0.0;
            for (int k = 0; k <= i; k++) {
              g += V[k][i + 1] * V[k][j];
            }
            for (int k = 0; k <= i; k++) {
              V[k][j] -= g * d[k];
            }
          }
        }
        for (int k = 0; k <= i; k++) {
          V[k][i + 1] = 0.0;
        }
      }
      for (int j = 0; j < n; j++) {
        d[j] = V[n - 1][j];
        V[n - 1][j] = 0.0;
      }
      V[n - 1][n - 1] = 1.0;
      e[0] = 0.0;
    }

    // Symmetric tridiagonal QL algorithm.

    void tql2() {
      //  This is derived from the Algol procedures tql2, by
      //  Bowdler, Martin, Reinsch, and Wilkinson, Handbook for
      //  Auto. Comp., Vol.ii-Linear Algebra, and the corresponding
      //  Fortran subroutine in EISPACK.

      for (int i = 1; i < n; i++) {
        e[i - 1] = e[i];
      }
      e[n - 1] = 0.0;

      double f = 0.0;
      double tst1 = 0.0;
      double eps = pow(2.0, -52.0).toDouble();
      for (int l = 0; l < n; l++) {
        // Find small subdiagonal element

        tst1 = max(tst1, d[l].abs() + e[l].abs());
        int m = l;
        while (m < n) {
          if (e[m].abs() <= eps * tst1) {
            break;
          }
          m++;
        }

        // If m == l, d[l] is an eigenvalue,
        // otherwise, iterate.

        if (m > l) {
          int iter = 0;
          do {
            iter = iter + 1; // (Could check iteration count here.)

            // Compute implicit shift

            double g = d[l];
            double p = (d[l + 1] - g) / (2.0 * e[l]);
            double r = hypot(p, 1.0).toDouble();
            if (p < 0) {
              r = -r;
            }
            d[l] = e[l] / (p + r);
            d[l + 1] = e[l] * (p + r);
            double dl1 = d[l + 1];
            double h = g - d[l];
            for (int i = l + 2; i < n; i++) {
              d[i] -= h;
            }
            f = f + h;

            // Implicit QL transformation.

            p = d[m];
            double c = 1.0;
            double c2 = c;
            double c3 = c;
            double el1 = e[l + 1];
            double s = 0.0;
            double s2 = 0.0;
            for (int i = m - 1; i >= l; i--) {
              c3 = c2;
              c2 = c;
              s2 = s;
              g = c * e[i];
              h = c * p;
              r = hypot(p, e[i]).toDouble();
              e[i + 1] = s * r;
              s = e[i] / r;
              c = p / r;
              p = c * d[i] - s * g;
              d[i + 1] = h + s * (c * g + s * d[i]);

              // Accumulate transformation.

              for (int k = 0; k < n; k++) {
                h = V[k][i + 1];
                V[k][i + 1] = s * V[k][i] + c * h;
                V[k][i] = c * V[k][i] - s * h;
              }
            }
            p = -s * s2 * c3 * el1 * e[l] / dl1;
            e[l] = s * p;
            d[l] = c * p;

            // Check for convergence.

          } while (e[l].abs() > eps * tst1);
        }
        d[l] = d[l] + f;
        e[l] = 0.0;
      }

      // Sort eigenvalues and corresponding vectors.

      for (int i = 0; i < n - 1; i++) {
        int k = i;
        double p = d[i];
        for (int j = i + 1; j < n; j++) {
          if (d[j] < p) {
            k = j;
            p = d[j];
          }
        }
        if (k != i) {
          d[k] = d[i];
          d[i] = p;
          for (int j = 0; j < n; j++) {
            p = V[j][i];
            V[j][i] = V[j][k];
            V[j][k] = p;
          }
        }
      }
    }

    // Nonsymmetric reduction to Hessenberg form.

    void orthes() {
      //  This is derived from the Algol procedures orthes and ortran,
      //  by Martin and Wilkinson, Handbook for Auto. Comp.,
      //  Vol.ii-Linear Algebra, and the corresponding
      //  Fortran subroutines in EISPACK.

      int low = 0;
      int high = n - 1;

      for (int m = low + 1; m <= high - 1; m++) {
        // Scale column.

        double scale = 0.0;
        for (int i = m; i <= high; i++) {
          scale = scale + H[i][m - 1].abs();
        }
        if (scale != 0.0) {
          // Compute Householder transformation.

          double h = 0.0;
          for (int i = high; i >= m; i--) {
            ort[i] = H[i][m - 1] / scale;
            h += ort[i] * ort[i];
          }
          double g = sqrt(h);
          if (ort[m] > 0) {
            g = -g;
          }
          h = h - ort[m] * g;
          ort[m] = ort[m] - g;

          // Apply Householder similarity transformation
          // H = (I-u*u'/h)*H*(I-u*u')/h)

          for (int j = m; j < n; j++) {
            double f = 0.0;
            for (int i = high; i >= m; i--) {
              f += ort[i] * H[i][j];
            }
            f = f / h;
            for (int i = m; i <= high; i++) {
              H[i][j] -= f * ort[i];
            }
          }

          for (int i = 0; i <= high; i++) {
            double f = 0.0;
            for (int j = high; j >= m; j--) {
              f += ort[j] * H[i][j];
            }
            f = f / h;
            for (int j = m; j <= high; j++) {
              H[i][j] -= f * ort[j];
            }
          }
          ort[m] = scale * ort[m];
          H[m][m - 1] = scale * g;
        }
      }

      // Accumulate transformations (Algol's ortran).

      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          V[i][j] = (i == j ? 1.0 : 0.0);
        }
      }

      for (int m = high - 1; m >= low + 1; m--) {
        if (H[m][m - 1] != 0.0) {
          for (int i = m + 1; i <= high; i++) {
            ort[i] = H[i][m - 1];
          }
          for (int j = m; j <= high; j++) {
            double g = 0.0;
            for (int i = m; i <= high; i++) {
              g += ort[i] * V[i][j];
            }
            // Double division avoids possible underflow
            g = (g / ort[m]) / H[m][m - 1];
            for (int i = m; i <= high; i++) {
              V[i][j] += g * ort[i];
            }
          }
        }
      }
    }

    // Complex scalar division.

    double cdivr = 0, cdivi = 0;
    void cdiv(double xr, double xi, double yr, double yi) {
      double r, d;
      if (yr.abs() > yi.abs()) {
        r = yi / yr;
        d = yr + r * yi;
        cdivr = (xr + r * xi) / d;
        cdivi = (xi - r * xr) / d;
      } else {
        r = yr / yi;
        d = yi + r * yr;
        cdivr = (r * xr + xi) / d;
        cdivi = (r * xi - xr) / d;
      }
    }

    // Nonsymmetric reduction from Hessenberg to real Schur form.

    void hqr2() {
      //  This is derived from the Algol procedure hqr2,
      //  by Martin and Wilkinson, Handbook for Auto. Comp.,
      //  Vol.ii-Linear Algebra, and the corresponding
      //  Fortran subroutine in EISPACK.

      // Initialize

      int nn = n;
      int inn = nn - 1;
      int low = 0;
      int high = nn - 1;
      double eps = pow(2.0, -52.0).toDouble();
      double exshift = 0.0;
      double p = 0, q = 0, r = 0, s = 0, z = 0, t, w, x, y;

      // Store roots isolated by balanc and compute matrix norm

      double norm = 0.0;
      for (int i = 0; i < nn; i++) {
        if (i < low || i > high) {
          d[i] = H[i][i];
          e[i] = 0.0;
        }
        for (int j = max(i - 1, 0); j < nn; j++) {
          norm = norm + H[i][j].abs();
        }
      }

      // Outer loop over eigenvalue index

      int iter = 0;
      while (inn >= low) {
        // Look for single small sub-diagonal element

        int l = inn;
        while (l > low) {
          s = H[l - 1][l - 1].abs() + H[l][l].abs();
          if (s == 0.0) {
            s = norm;
          }
          if (H[l][l - 1].abs() < eps * s) {
            break;
          }
          l--;
        }

        // Check for convergence
        // One root found

        if (l == inn) {
          H[inn][inn] = H[inn][inn] + exshift;
          d[inn] = H[inn][inn];
          e[inn] = 0.0;
          inn--;
          iter = 0;

          // Two roots found

        } else if (l == inn - 1) {
          w = H[inn][inn - 1] * H[inn - 1][inn];
          p = (H[inn - 1][inn - 1] - H[inn][inn]) / 2.0;
          q = p * p + w;
          z = sqrt(q.abs());
          H[inn][inn] = H[inn][inn] + exshift;
          H[inn - 1][inn - 1] = H[inn - 1][inn - 1] + exshift;
          x = H[inn][inn];

          // Real pair

          if (q >= 0) {
            if (p >= 0) {
              z = p + z;
            } else {
              z = p - z;
            }
            d[inn - 1] = x + z;
            d[inn] = d[inn - 1];
            if (z != 0.0) {
              d[inn] = x - w / z;
            }
            e[inn - 1] = 0.0;
            e[inn] = 0.0;
            x = H[inn][inn - 1];
            s = x.abs() + z.abs();
            p = x / s;
            q = z / s;
            r = sqrt(p * p + q * q);
            p = p / r;
            q = q / r;

            // Row modification

            for (int j = n - 1; j < nn; j++) {
              z = H[inn - 1][j];
              H[inn - 1][j] = q * z + p * H[inn][j];
              H[inn][j] = q * H[inn][j] - p * z;
            }

            // Column modification

            for (int i = 0; i <= inn; i++) {
              z = H[i][inn - 1];
              H[i][inn - 1] = q * z + p * H[i][inn];
              H[i][inn] = q * H[i][inn] - p * z;
            }

            // Accumulate transformations

            for (int i = low; i <= high; i++) {
              z = V[i][inn - 1];
              V[i][inn - 1] = q * z + p * V[i][inn];
              V[i][inn] = q * V[i][inn] - p * z;
            }

            // Complex pair

          } else {
            d[inn - 1] = x + p;
            d[inn] = x + p;
            e[inn - 1] = z;
            e[inn] = -z;
          }
          inn = inn - 2;
          iter = 0;

          // No convergence yet

        } else {
          // Form shift

          x = H[inn][inn];
          y = 0.0;
          w = 0.0;
          if (l < inn) {
            y = H[inn - 1][inn - 1];
            w = H[inn][inn - 1] * H[inn - 1][inn];
          }

          // Wilkinson's original ad hoc shift

          if (iter == 10) {
            exshift += x;
            for (int i = low; i <= inn; i++) {
              H[i][i] -= x;
            }
            s = H[inn][inn - 1].abs() + H[inn - 1][inn - 2].abs();
            x = y = 0.75 * s;
            w = -0.4375 * s * s;
          }

          // MATLAB's new ad hoc shift

          if (iter == 30) {
            s = (y - x) / 2.0;
            s = s * s + w;
            if (s > 0) {
              s = sqrt(s);
              if (y < x) {
                s = -s;
              }
              s = x - w / ((y - x) / 2.0 + s);
              for (int i = low; i <= inn; i++) {
                H[i][i] -= s;
              }
              exshift += s;
              x = y = w = 0.964;
            }
          }

          iter = iter + 1; // (Could check iteration count here.)

          // Look for two consecutive small sub-diagonal elements

          int m = inn - 2;
          while (m >= l) {
            z = H[m][m];
            r = x - z;
            s = y - z;
            p = (r * s - w) / H[m + 1][m] + H[m][m + 1];
            q = H[m + 1][m + 1] - z - r - s;
            r = H[m + 2][m + 1];
            s = p.abs() + q.abs() + r.abs();
            p = p / s;
            q = q / s;
            r = r / s;
            if (m == l) {
              break;
            }
            if (H[m][m - 1].abs() * (q.abs() + r.abs()) <
                eps *
                    (p.abs() *
                        (H[m - 1][m - 1].abs() +
                            z.abs() +
                            H[m + 1][m + 1].abs()))) {
              break;
            }
            m--;
          }

          for (int i = m + 2; i <= inn; i++) {
            H[i][i - 2] = 0.0;
            if (i > m + 2) {
              H[i][i - 3] = 0.0;
            }
          }

          // Double QR step involving rows l:n and columns m:n

          for (int k = m; k <= inn - 1; k++) {
            bool notlast = (k != inn - 1);
            if (k != m) {
              p = H[k][k - 1];
              q = H[k + 1][k - 1];
              r = (notlast ? H[k + 2][k - 1] : 0.0);
              x = p.abs() + q.abs() + r.abs();
              if (x != 0.0) {
                p = p / x;
                q = q / x;
                r = r / x;
              }
            }
            if (x == 0.0) {
              break;
            }
            s = sqrt(p * p + q * q + r * r);
            if (p < 0) {
              s = -s;
            }
            if (s != 0) {
              if (k != m) {
                H[k][k - 1] = -s * x;
              } else if (l != m) {
                H[k][k - 1] = -H[k][k - 1];
              }
              p = p + s;
              x = p / s;
              y = q / s;
              z = r / s;
              q = q / p;
              r = r / p;

              // Row modification

              for (int j = k; j < nn; j++) {
                p = H[k][j] + q * H[k + 1][j];
                if (notlast) {
                  p = p + r * H[k + 2][j];
                  H[k + 2][j] = H[k + 2][j] - p * z;
                }
                H[k][j] = H[k][j] - p * x;
                H[k + 1][j] = H[k + 1][j] - p * y;
              }

              // Column modification

              for (int i = 0; i <= min(inn, k + 3); i++) {
                p = x * H[i][k] + y * H[i][k + 1];
                if (notlast) {
                  p = p + z * H[i][k + 2];
                  H[i][k + 2] = H[i][k + 2] - p * r;
                }
                H[i][k] = H[i][k] - p;
                H[i][k + 1] = H[i][k + 1] - p * q;
              }

              // Accumulate transformations

              for (int i = low; i <= high; i++) {
                p = x * V[i][k] + y * V[i][k + 1];
                if (notlast) {
                  p = p + z * V[i][k + 2];
                  V[i][k + 2] = V[i][k + 2] - p * r;
                }
                V[i][k] = V[i][k] - p;
                V[i][k + 1] = V[i][k + 1] - p * q;
              }
            } // (s != 0)
          } // k loop
        } // check convergence
      } // while (n >= low)

      // Backsubstitute to find vectors of upper triangular form

      if (norm == 0.0) {
        return;
      }

      for (inn = nn - 1; inn >= 0; inn--) {
        p = d[inn];
        q = e[inn];

        // Real vector

        if (q == 0) {
          int l = inn;
          H[inn][inn] = 1.0;
          for (int i = inn - 1; i >= 0; i--) {
            w = H[i][i] - p;
            r = 0.0;
            for (int j = l; j <= inn; j++) {
              r = r + H[i][j] * H[j][inn];
            }
            if (e[i] < 0.0) {
              z = w;
              s = r;
            } else {
              l = i;
              if (e[i] == 0.0) {
                if (w != 0.0) {
                  H[i][inn] = -r / w;
                } else {
                  H[i][inn] = -r / (eps * norm);
                }

                // Solve real equations

              } else {
                x = H[i][i + 1];
                y = H[i + 1][i];
                q = (d[i] - p) * (d[i] - p) + e[i] * e[i];
                t = (x * s - z * r) / q;
                H[i][n] = t;
                if (x.abs() > z.abs()) {
                  H[i + 1][inn] = (-r - w * t) / x;
                } else {
                  H[i + 1][inn] = (-s - y * t) / z;
                }
              }

              // Overflow control

              t = H[i][inn].abs();
              if ((eps * t) * t > 1) {
                for (int j = i; j <= inn; j++) {
                  H[j][inn] = H[j][inn] / t;
                }
              }
            }
          }

          // Complex vector

        } else if (q < 0) {
          int l = inn - 1;

          // Last vector component imaginary so matrix is triangular

          if (H[inn][inn - 1].abs() > H[inn - 1][inn].abs()) {
            H[inn - 1][inn - 1] = q / H[inn][inn - 1];
            H[inn - 1][inn] = -(H[inn][inn] - p) / H[inn][inn - 1];
          } else {
            cdiv(0.0, -H[inn - 1][inn], H[inn - 1][inn - 1] - p, q);
            H[inn - 1][inn - 1] = cdivr;
            H[inn - 1][inn] = cdivi;
          }
          H[inn][inn - 1] = 0.0;
          H[inn][inn] = 1.0;
          for (int i = inn - 2; i >= 0; i--) {
            double ra, sa, vr, vi;
            ra = 0.0;
            sa = 0.0;
            for (int j = l; j <= inn; j++) {
              ra = ra + H[i][j] * H[j][inn - 1];
              sa = sa + H[i][j] * H[j][inn];
            }
            w = H[i][i] - p;

            if (e[i] < 0.0) {
              z = w;
              r = ra;
              s = sa;
            } else {
              l = i;
              if (e[i] == 0) {
                cdiv(-ra, -sa, w, q);
                H[i][inn - 1] = cdivr;
                H[i][inn] = cdivi;
              } else {
                // Solve complex equations

                x = H[i][i + 1];
                y = H[i + 1][i];
                vr = (d[i] - p) * (d[i] - p) + e[i] * e[i] - q * q;
                vi = (d[i] - p) * 2.0 * q;
                if (vr == 0.0 && vi == 0.0) {
                  vr = eps *
                      norm *
                      (w.abs() + q.abs() + x.abs() + y.abs() + z.abs());
                }
                cdiv(x * r - z * ra + q * sa, x * s - z * sa - q * ra, vr, vi);
                H[i][inn - 1] = cdivr;
                H[i][inn] = cdivi;
                if (x.abs() > (z.abs() + q.abs())) {
                  H[i + 1][inn - 1] =
                      (-ra - w * H[i][inn - 1] + q * H[i][inn]) / x;
                  H[i + 1][inn] = (-sa - w * H[i][inn] - q * H[i][inn - 1]) / x;
                } else {
                  cdiv(-r - y * H[i][inn - 1], -s - y * H[i][inn], z, q);
                  H[i + 1][inn - 1] = cdivr;
                  H[i + 1][inn] = cdivi;
                }
              }

              // Overflow control

              t = max(H[i][inn - 1].abs(), H[i][inn].abs());
              if ((eps * t) * t > 1) {
                for (int j = i; j <= inn; j++) {
                  H[j][inn - 1] = H[j][inn - 1] / t;
                  H[j][inn] = H[j][inn] / t;
                }
              }
            }
          }
        }
      }

      // Vectors of isolated roots

      for (int i = 0; i < nn; i++) {
        if (i < low || i > high) {
          for (int j = i; j < nn; j++) {
            V[i][j] = H[i][j];
          }
        }
      }

      // Back transformation to get eigenvectors of original matrix

      for (int j = nn - 1; j >= low; j--) {
        for (int i = low; i <= high; i++) {
          z = 0.0;
          for (int k = low; k <= min(j, high); k++) {
            z = z + V[i][k] * H[k][j];
          }
          V[i][j] = z;
        }
      }
    }

/* ------------------------
   Constructor
 * ------------------------ */

    /** Check for symmetry, then construct the eigenvalue decomposition
   @param A    Square matrix
   @return     Structure to access D and V.
   */

    final A = data;

    issymmetric = true;
    for (int j = 0; (j < n) & issymmetric; j++) {
      for (int i = 0; (i < n) & issymmetric; i++) {
        issymmetric = (A[i][j] == A[j][i]);
      }
    }

    if (issymmetric) {
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          V[i][j] = A[i][j].toDouble();
        }
      }

      // Tridiagonalize.
      tred2();

      // Diagonalize.
      tql2();
    } else {
      for (int j = 0; j < n; j++) {
        for (int i = 0; i < n; i++) {
          H[i][j] = A[i][j].toDouble();
        }
      }

      // Reduce to Hessenberg form.
      orthes();

      // Reduce Hessenberg to real Schur form.
      hqr2();
    }

    final result = <num, Vector>{};

    final D = SquareMatrix.generate(n).data;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        D[i][j] = 0.0;
      }
      D[i][i] = d[i];
      if (e[i] > 0) {
        D[i][i + 1] = e[i];
      } else if (e[i] < 0) {
        D[i][i - 1] = e[i];
      }
    }

    final eigenValues = SquareMatrix(D).mainDiagonal();
    final eigenVectors = Matrix(V);
    for (var i = 1; i <= eigenValues.itemsCount; i++) {
      result[eigenValues.itemAt(i)] = eigenVectors.columnAsVector(i);
    }
    return result;
  }

  /// Calculates Cholesky decomposition of this `positive definite matrix`,
  /// otherwise returns `null`
  ///
  /// Returns only upper triangular matrix. To get second matrix
  /// `transpose` returned matrix.
  ///
  /// Created from [Jama's implemetation](https://github.com/fiji/Jama/blob/master/src/main/java/Jama/CholeskyDecomposition.java).
  SquareMatrix cholesky() {
    var m = SquareMatrix([]);
    if (isPositiveDefinite()) {
      /* ------------------------
   Class variables
 * ------------------------ */

      /** Array for internal storage of decomposition.
   @serial internal array storage.
   */
      List<List<num>> L;

      /** Row and column dimension (square matrix).
   @serial matrix dimension.
   */
      int n;

      /** Symmetric and positive definite flag.
   @serial is symmetric and positive definite flag.
   */
      bool isspd;

/* ------------------------
   Constructor
 * ------------------------ */

      /** Cholesky algorithm for symmetric and positive definite matrix.
   @param  A   Square, symmetric matrix.
   @return     Structure to access L and isspd flag.
   */

      // Initialize.
      final A = data;
      n = rows;
      L = SquareMatrix.generate(n).data;
      isspd = (columns == n);
      // Main loop.
      for (int j = 0; j < n; j++) {
        final Lrowj = L[j];
        double d = 0.0;
        for (int k = 0; k < j; k++) {
          final Lrowk = L[k];
          double s = 0.0;
          for (int i = 0; i < k; i++) {
            s += Lrowk[i] * Lrowj[i];
          }
          Lrowj[k] = s = (A[j][k] - s) / L[k][k];
          d = d + s * s;
          isspd = isspd & (A[k][j] == A[j][k]);
        }
        d = A[j][j] - d;
        isspd = isspd & (d > 0.0);
        L[j][j] = sqrt(max(d, 0.0));
        for (int k = j + 1; k < n; k++) {
          L[j][k] = 0.0;
        }
      }

      m = SquareMatrix(L);
    }
    return m;
  }

  /// Calculates LU decomposition of this matrix with partial pivoting
  ///
  /// Returns `Map` object where `upper` key contains
  /// **upper triangular matrix**, `lower` key contains **lower triangular
  /// matrix**, `pivote` key contains **permutation matrix**.
  Map<String, SquareMatrix> lu() {
    final thisCopy = copy();
    final lower = SquareMatrix.identity(rows);

    for (var c = 1; c < columns; c++) {
      for (var r = c + 1; r <= rows; r++) {
        final divide = thisCopy.itemAt(r, c) / thisCopy.itemAt(c, c);
        lower.setItem(r, c, divide);
        thisCopy.replaceRow(r,
            (thisCopy.rowAsVector(c) * -divide + thisCopy.rowAsVector(r)).data);
      }
    }

    final upper = gaussian().toSquareMatrix();
    final pivote = _pivotize();

    return <String, SquareMatrix>{
      'upper': upper,
      'lower': lower,
      'pivote': pivote
    };
  }

  /// Rearranging the rows of `A`, prior to the `LU` decomposition, in
  /// a way that the largest element of each column gets onto
  /// the diagonal of `A`
  SquareMatrix _pivotize() {
    final m = copy();
    final id = SquareMatrix.identity(m.rows);

    for (var i = 1; i <= m.rows; i++) {
      var maxm = m.itemAt(i, i);
      var row = i;

      for (var j = i; j < m.rows; j++) {
        if (m.itemAt(j, i) > maxm) {
          maxm = m.itemAt(j, i);
          row = j;
        }
      }

      if (i != row) {
        final tmp = id.rowAt(i);
        id..replaceRow(i, id.rowAt(row))..replaceRow(row, tmp);
      }
    }
    return id;
  }

  /// Performs Gaussian-Jordan elimination of this matrix and [equalTo]
  /// as right-side of augmented matrix
  ///
  /// [equalTo] should be equal to [rows].
  Vector eliminate(List<num> equalTo) {
    final eliminatedMatrix = copy();
    final result = equalTo;

    for (var i = 1; i <= rows; i++) {
      if (eliminatedMatrix.itemAt(i, i) == 0) {
        final col = eliminatedMatrix.columnAt(i);
        final row = eliminatedMatrix.rowAt(i);

        final indexCol = row.indexWhere((n) => n != 0, i - 1);
        final indexRow = col.indexWhere((n) => n != 0, i - 1);

        if (indexRow != -1) {
          eliminatedMatrix.swapRows(i, indexRow + 1);

          final value = result[i - 1];
          result[i - 1] = result[indexRow];
          result[indexRow] = value;
        } else if (indexCol != -1) {
          eliminatedMatrix.swapColumns(i, indexCol + 1);
        }
      }

      final element = eliminatedMatrix.itemAt(i, i) == 0
          ? 1
          : eliminatedMatrix.itemAt(i, i);
      final choosedRow =
          eliminatedMatrix.rowAt(i).map((v) => v / element).toList();
      eliminatedMatrix.replaceRow(i, choosedRow);
      result[i - 1] /= element;

      for (var j = i + 1; j <= rows; j++) {
        final diff =
            eliminatedMatrix.itemAt(j, i) / eliminatedMatrix.itemAt(i, i);
        final tmpRow = Vector(choosedRow).map((v) => v * -diff) +
            Vector(eliminatedMatrix.rowAt(j));

        result[j - 1] += result[i - 1] * -diff;
        eliminatedMatrix.replaceRow(j, tmpRow.data);
      }
    }

    for (var i = rows; i >= 1; i--) {
      final choosedRow = eliminatedMatrix.rowAt(i);

      for (var j = i - 1; j >= 1; j--) {
        final tmpRow =
            Vector(choosedRow).map((v) => v * -eliminatedMatrix.itemAt(j, i)) +
                Vector(eliminatedMatrix.rowAt(j));

        result[j - 1] += result[i - 1] * -eliminatedMatrix.itemAt(j, i);
        eliminatedMatrix.replaceRow(j, tmpRow.data);
      }
    }

    return Vector(result);
  }

  @override
  SquareMatrix copy() => SquareMatrix(data);
}
