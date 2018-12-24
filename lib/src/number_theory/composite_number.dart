import 'primes.dart';

/// Class gets prime numbers of composite number
class CompositeNumber {
  /// Accept composite number
  CompositeNumber(this.composite);

  /// Composite number
  double composite;

  /// Gets prime numbers of [composite]
  Set<double> factorizate() {
    final result = Set<double>();

    if (isPrime()) {
      result.addAll(<double>[1, composite]);
    } else {
      var counter = 0;
      while (composite != 1) {
        if (composite % primes[counter] == 0) {
          result.add(primes[counter]);
          composite /= primes[counter];
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
