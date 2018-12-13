import 'package:extended_math/extended_math.dart';

void main() {

  final v3 = SquareMatrix(<List<double>>[
    <double>[4, -2],
    <double>[1, 6]
  ]);
  print(v3.transpose().data);
  // print(v3.getDeterminant());
  // print(v3.inverse().data);
  // print(v3.inverse().multiplyByMatrix(v3).data);
}
