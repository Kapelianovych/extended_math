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
  /// Double(0.876026).preciseTo(3) == Double(0.876);
  /// Double(0.076026).preciseTo(3) == Double(0.076);
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
      // Numbers like 0.0...082736... transform to 100...082736... integers
      var result = double.parse(
        '${splittedNumber[0] == '0' ? '1' : ''}$_value'
        .split('').where((n) => n != '.').join());
      // Precise [result]
      while ('${result.toInt()}'.length != count + splittedNumber[0].length + (splittedNumber[0] == '0' ? 1 : 0)) {
        result = (result / 10).roundToDouble();
      }

      result /= pow(10, count);
      // Remove 1 from [result] if original number is like 0.0...0987...
      if (splittedNumber[0] == '0') {
        result = double.parse('$result'.substring(1));
      }

      return Double(result);
    }
  }
}
