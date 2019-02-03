import 'dart:math';

//import 'package:data/matrix.dart';
//import 'package:data/type.dart';
import 'package:extended_math/extended_math.dart';

void main() {
  final rows = <List<num>>[
    [12, -51, 4],
    [6, 167, -68],
    [-4, 24, -41],
  ];
  //print(qr(Matrix.builder.withType(DataType.numeric).fromRows(rows)).upper);

  // final matrix = TensorBase.generate(<String, int>{'width': 4, 'length': 2, 'depth' : 2}, (_) => 7);
  // // print('${matrix.toTensor3().dimension} - matrix');

  final map = SquareMatrix([
    [12, -51, 4],
    [6, 167, -68],
    [-4, 24, -41],
  ]);
  print(map.qr());
  //print(map['lower'].toMatrix().matrixProduct(map['upper'].toMatrix()));
}
