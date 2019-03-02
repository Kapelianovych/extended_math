import 'package:extended_math/extended_math.dart';

void main() {
  final v1 = Vector(<double>[1, 2, 3]);
  final v2 = Vector(<double>[4, 5, 6]);
  // Multiply vectors
  final double res = v1.dot(v2);
  // Add vectors
  final Vector res1 = v1 + v2;

  final v5 = Vector(<double>[6, 3]);
  final v6 = Vector(<double>[5, 13]);
  // Gets angle between two vectors
  print(v5.angleBetween(v6));

  final v3 = SquareMatrix(<List<double>>[
    <double>[9, 3, 5], 
    <double>[-6, -9, 7], 
    <double>[-1, -8, 1]
  ]);
  // Gets determinant of matrix
  final double det = v3.determinant();

  // Computes eigenvalues and eigenvectors of square matrix
  final Map<num, Vector> result = v3.eigen();

  final m = Matrix(<List<double>>[
    <double>[2, -1, 5],
    <double>[0, 2, 1],
    <double>[3, 1, 1]
  ]);
  // Computes Frobenius norm of matrix
  print(m.frobeniusNorm());

  final c = Complex(re: -4);
  final c2 = Complex(re: -4);
  // Gets root of complex number
  final r = c.rootsOf(2);
  // Divides complex numbers
  print(c / c2);
  // Gets pow of complex number
  print(Complex(re: 2).pow(2));
}