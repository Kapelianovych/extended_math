import 'primes.dart';

/// Class gets prime numbers of composite number
class CompositeNumber {
  /// Accept composite number
  CompositeNumber(this.composite);

  /// Composite number
  int composite;

  /// Gets unique prime numbers of [composite]
  Set<int> factorizate() {
    final result = Set<int>();

    if (isPrime()) {
      result.addAll(<int>[1, composite]);
    } else {
      var o = composite.toDouble();
      var counter = 0;

      while (!CompositeNumber(o.toInt()).isPrime()) {
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

  /// Checks if [composite] number is prime
  bool isPrime() {
    for (var item in primes) {
      if (composite % item == 0 && composite != item) {
        return false;
      }
    }
    return true;
  }
}
