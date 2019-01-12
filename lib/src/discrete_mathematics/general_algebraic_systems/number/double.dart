import 'dart:math';

import 'base/number.dart';

/// Class that provide type in equivalence of Dart's `double`
///
/// This class doesn't replace `double` type but implement methods that don't exist in.
class Double extends Number {
  /// Creates instance of [Double] number
  Double(double value) : super(value) {
    _value = value;
  }

  /// Internal value fo [Double]
  double _value;

  /// Returns [Double] number precised to [count] number after point
  ///
  /// Example:
  /// ```dart
  /// Double(4.876026).preciseTo(0) == Double(5);
  /// Double(4.876026).preciseTo(1) == Double(4.9);
  /// Double(4.876026).preciseTo(2) == Double(4.88);
  /// Double(4.876026).preciseTo(3) == Double(4.876);
  /// ```
  /// [count] should be positive integer number.
  Double preciseTo(int count) {
    final splittedNumber = '$_value'.split('.');

    if (splittedNumber[1] == '0') {
      return Double(_value);
    }

    if (count == 0) {
      return Double(_value.roundToDouble());
    } else {
      var result = _value * pow(10, splittedNumber[1].length);

      while ('${result.toInt()}'.length != count + splittedNumber[0].length) {
        result = (result / 10).roundToDouble();
      }
      return Double(result / pow(10, count));
    }
  }
}
