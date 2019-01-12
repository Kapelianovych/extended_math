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
}
