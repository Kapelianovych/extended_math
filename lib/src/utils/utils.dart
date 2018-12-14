import 'dart:math';

/// Generates [count] random numbers
Iterable<double> generateNumbers(int count) sync* {
  var i = 0;
  while (i < count) {
    i++;
    yield Random().nextDouble();
  }
}
