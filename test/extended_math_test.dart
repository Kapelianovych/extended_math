import 'dart:math';

import 'package:extended_math/extended_math.dart';

void main() {
  final m = Tensor3(<List<List<num>>>[<List<num>>[<num>[1, 2, 3, 4, 5]]]);
  final mean = Mean(m);
  print(mean.harmonic());

  final matrix = TensorBase.generate(<String, int>{'width': 4, 'length': 2, 'depth' : 2}, (_) => 7);
  // print('${matrix.toTensor3().dimension} - matrix');
}
