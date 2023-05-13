import 'dart:math';

/// Generator of random numbers
///
/// It isn't extend `Random` of `dart:math`, but provide functionality
/// that don't exist in.
class NumbersGenerator {
  /// Holds cryptographically secure [Random] object
  final Random r = Random.secure();

  /// Generates `integer` number in range [from] - [to] inclusively
  ///
  /// [from] should be less than [to].
  int nextInt(int to, {int from = 0}) => r.nextInt(to + 1 - from) + from;

  /// Generates `double` number in range [from] - [to] inclusively
  ///
  /// [from] should be less than [to].
  double nextDouble({double from = 0, double to = 1}) =>
      r.nextDouble() * (to + 0.001 - from) + from;

  /// Returns iterable of integer numbers
  ///
  /// Generates `integer` number in range [from] - [to] inclusively.
  /// [from] should be less than [to].
  Iterable<int> intIterableSync({required int to, int from = 0}) sync* {
    while (true) {
      yield nextInt(to, from: from);
    }
  }

  /// Returns iterable of double numbers
  ///
  /// Generates `double` number in range [from] - [to] inclusively.
  /// [from] should be less than [to].
  Iterable<double> doubleIterableSync({double from = 0, double to = 1}) sync* {
    while (true) {
      yield nextDouble(from: from, to: to);
    }
  }
}
