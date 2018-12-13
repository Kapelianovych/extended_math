import 'package:extended_math/extended_math.dart';

void main() {

  final m = Matrix(<List<double>>[
    <double>[2, -1, 5],
    <double>[0, 2, 1],
    <double>[3, 1, 1]
  ]);
  print(m.frobeniusNorm());

  final v1 = Vector(<double>[6, 3]);
  final v2 = Vector(<double>[5, 13]);
  print(v1.angleBetween(v2));
}
