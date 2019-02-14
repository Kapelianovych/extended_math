import 'dart:math';

//import 'package:data/matrix.dart';
//import 'package:data/type.dart';
import 'package:extended_math/extended_math.dart';

void main() {
  final p = UniformDistribution(.45);
  print(p.centralMoment(2));
}
