import '../../number_theory/primes.dart';
import 'base/number.dart';

/// Class that provide type in equivalence of Dart's `int`
///
/// This class doesn't replace `int` type but implement methods that don't exist in.
class Integer extends Number {
  /// Creates instance of [Integer] number
  Integer(int value) : super(value) {
    _value = value;
  }

  /// Internal value fo [Integer]
  int _value;

  /// Gets unique prime numbers of this number
  Set<int> factorizate() {
    final result = Set<int>();

    if (isPrime()) {
      result.addAll(<int>[1, _value]);
    } else {
      var o = _value.toDouble();
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
    for (var item in primes) {
      if (_value % item == 0 && _value != item) {
        return false;
      }
    }
    return true;
  }
}
