import 'dart:math';

import '../../../../complex_analysis/complex.dart';
import '../../../linear_algebra/tensor/base/tensor_base.dart';
import '../double.dart';
import '../exceptions/division_by_zero_exception.dart';

/// Class that provide type in equivalence of Dart's `num`
///
/// This class doesn't replace `num` type but implement
/// methods that don't exist in.
class Number extends TensorBase {
  /// Creates instance of [Number] by accepting number or it will be equal to 0
  const Number(this._value) : super(0);

  /// Internal value of number
  final num _value;

  @override
  int get itemsCount => 1;

  @override
  num get data => _value;

  @override
  List<int> get shape => []; // Empty because numbers haven't shape

  /// Gets nth root of this number
  ///
  /// [degree] may be only positive number.
  Double rootOf(num degree) {
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
  int toInt() => data.toInt();

  /// Returns the result as an `double`
  double toDouble() => data.toDouble();

  /// Add this to [other]
  ///
  /// [other] can be either `num` or [Number].
  @override
  Number operator +(Object other) {
    var n = Number(0);
    if (other is num) {
      n = Number(_value + other);
    } else if (other is Number) {
      n = Number(_value + other.data);
    }
    return n;
  }

  @override
  Number operator -() => Number(-_value);

  /// Subtract [other] from this
  ///
  /// [other] can be either `num` or [Number].
  @override
  Number operator -(Object other) {
    var n = Number(0);
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
  @override
  Number operator *(Object other) {
    var n = Number(0);
    if (other is num) {
      n = Number(_value * other);
    } else if (other is Number) {
      n = Number(_value * other.data);
    }
    return n;
  }

  /// Divide this by [other]
  ///
  /// [other] can be either `num` or [Number].
  @override
  Double operator /(Object other) {
    var n = Double(0);
    if (other is num) {
      if (other == 0) {
        throw DivisionByZeroException();
      }
      n = Double(_value / other);
    } else if (other is Number) {
      if (other.data == 0) {
        throw DivisionByZeroException();
      }
      n = Double(_value / other.data);
    }
    return n;
  }

  @override
  bool operator ==(Object other) {
    var result = false;
    if (other is num) {
      result = _value == other;
    } else if (other is Number) {
      result = _value == other.data;
    }
    return result;
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  Number map(num Function(num number) f) => Number(toList().map(f).single);

  @override
  bool every(bool Function(num number) f) => toList().every(f);

  @override
  bool any(bool Function(num number) f) => every(f);

  @override
  num reduce(num Function(num prev, num next) f) => toList().reduce(f);

  @override
  List<num> toList() => <num>[_value];

  /// Converts this number to complex number
  Complex toComplex() => Complex(re: data);

  @override
  String toString() => '$_value';
}
