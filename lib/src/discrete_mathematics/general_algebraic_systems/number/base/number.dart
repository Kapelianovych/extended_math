import 'dart:math';

import '../../../../mixins/copyable_mixin.dart';
import '../double.dart';
import '../exception/division_by_zero_exception.dart';

/// Class that provide type in equivalence of Dart's `num`
///
/// This class doesn't replace `num` type but implement methods that don't exist in.
class Number with CopyableMixin<Number> {
  /// Creates instance of [Number] by accepting number or it will be equal to 0
  Number(this._value);

  /// Internal value of number
  num _value;

  /// Gets nth root of this number
  ///
  /// [degree] may bo only positive integer number.
  Double rootOf(int degree) {
    if (_value == 0) {
      return Double(0);
    }

    if (degree == 0) {
      return Double(0);
    }

    var result = _value;
    var delta = -2147483647.0;

    while (-delta.abs() < -0.001) {
      delta = (1 / degree) * (_value / pow(result, degree - 1) - result);
      result += delta;
    }
    return Double(result.toDouble());
  }

  @override
  Number copy() => Number(_value);

  /// Truncates this [_value] to an integer and returns the result as an `int`
  int toInt() => _value.toInt();

  /// Returns the result as an `double`
  double toDouble() => _value.toDouble();

  /// Add this to [other]
  ///
  /// [other] can be either `num` or [Number].
  Number operator +(Object other) {
    Number n;
    if (other is num) {
      n = Number(_value + other);
    } else if (other is Number) {
      n = Number(_value + other._value);
    }
    return n;
  }

  /// Negate operator
  Number operator -() => Number(-_value);

  /// Subtract [other] from this
  ///
  /// [other] can be either `num` or [Number].
  Number operator -(Object other) {
    Number n;
    if (other is num) {
      n = Number(_value - other);
    } else if (other is Number) {
      n = this + -other;
    }
    return n;
  }

  /// Multiply this by [other]
  ///
  /// [other] can be either `num` or [Number].
  Number operator *(Object other) {
    Number n;
    if (other is num) {
      n = Number(_value * other);
    } else if (other is Number) {
      n = Number(_value * other._value);
    }
    return n;
  }

  /// Divide this by [other]
  ///
  /// [other] can be either `num` or [Number].
  Number operator /(Object other) {
    Number n;
    if (other is num) {
      if (other == 0) {
        throw DivisionByZeroException();
      }
      n = Number(_value / other);
    } else if (other is Number) {
      if (other._value == 0) {
        throw DivisionByZeroException();
      }
      n = Number(_value / other._value);
    }
    return n;
  }

  @override
  bool operator ==(Object other) {
    bool result;
    if (other is num) {
      result = _value == other;
    } else if (other is Number) {
      result = _value == other._value;
    }
    return result;
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => '$_value';
}
