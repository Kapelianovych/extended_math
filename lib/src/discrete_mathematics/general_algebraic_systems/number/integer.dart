import '../../number_theory/primes.dart';
import 'base/number.dart';

/// Class that provide type in equivalence of Dart's `int`
///
/// This class doesn't replace `int` type but implement
/// methods that don't exist in.
class Integer extends Number {
  /// Creates instance of [Integer] number
  const Integer(int value) : super(value);

  @override
  int get data => super.data.toInt();

  /// Gets unique prime numbers of this number
  Set<int> factorizate() {
    final result = <int>{};

    if (isPrime()) {
      result.addAll(<int>[1, data]);
    } else {
      var o = data.toDouble();
      var counter = 0;

      while (!Integer(o.toInt()).isPrime()) {
        if (o % primes[counter] == 0) {
          result.add(primes[counter]);
          o /= primes[counter];
        } else {
          counter++;
        }
      }
    }

    return result;
  }

  /// Checks if number is prime
  bool isPrime() {
    for (final item in primes) {
      if (data % item == 0 && data != item) {
        return false;
      }
    }
    return true;
  }
}
