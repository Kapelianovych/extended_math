import 'package:extended_math/extended_math.dart';

void main() {
  final v1 = Vector(<double>[1, 2, 3]);
  final v2 = Vector(<double>[4, 5, 6]);

  // Multiply vectors
  final double res = v1.dot(v2);
  // Add vectors
  final Vector res1 = v1.add(v2);

  final v3 = SquareMatrix(<List<double>>[
    <double>[9, 3, 5], 
    <double>[-6, -9, 7], 
    <double>[-1, -8, 1]
  ]);
  // Gets determinant of matrix
  final double det = v3.getDeterminant();
}