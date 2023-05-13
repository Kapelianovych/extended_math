import 'dart:math' as m;

import 'package:quiver/core.dart';

import '../discrete_mathematics/general_algebraic_systems/number/base/number.dart';
import '../discrete_mathematics/general_algebraic_systems/number/double.dart';
import '../discrete_mathematics/linear_algebra/tensor/tensor1/vector.dart';
import '../mixins/copyable_mixin.dart';
import 'exceptions/complex_exception.dart';

/// Defines type for number i of complex analysis
class Complex with CopyableMixin<Complex> {
  /// Creates instance of complex number with [re] and [in] equals to zero
  const Complex({this.re = 0, this.im = 0});

  /// Real part of i
  final num re;

  /// Imaginary part of i
  final num im;

  /// Module of this
  num get module => Vector(<num>[re, im]).length;

  /// Argument of this (angle of the radius Oz, where z is this)
  num get argument {
    if (re >= 0) {
      return m.atan(im / re);
    } else {
      return m.atan(im / re) + m.pi;
    }
  }

  /// Add this to another [other]
  ///
  /// [other] can be either number or complex number.
  Complex operator +(Object other) {
    var c = Complex();
    if (other is num) {
      c = Complex(re: re + other, im: im);
    } else if (other is Complex) {
      c = Complex(re: re + other.re, im: im + other.im);
    } else if (other is Number) {
      c = Complex(re: re + other.toDouble(), im: im);
    }
    return c;
  }

  /// Subtract [other] from this
  ///
  /// [other] can be either number or complex number.
  Complex operator -(Object other) {
    var c = Complex();
    if (other is Complex) {
      c = this + -other;
    } else if (other is num) {
      c = Complex(re: re - other, im: im);
    } else if (other is Number) {
      c = this + -other;
    }
    return c;
  }

  /// Unary minus of this
  Complex operator -() => Complex(re: -re, im: -im);

  /// Multiply this i by [other]
  ///
  /// [other] can be either number or complex number.
  Complex operator *(Object other) {
    var c = Complex();
    if (other is num) {
      final newRe = re * other;
      final newIm = im * other;
      c = Complex(re: newRe, im: newIm);
    } else if (other is Complex) {
      final newRe = re * other.re - im * other.im;
      final newIm = re * other.im + im * other.re;
      c = Complex(re: newRe, im: newIm);
    } else if (other is Number) {
      final newRe = re * other.toDouble();
      final newIm = im * other.toDouble();
      c = Complex(re: newRe, im: newIm);
    }
    return c;
  }

  /// Divide this i by [other]
  ///
  /// [other] can be either number or complex number.
  Complex operator /(Object other) {
    var c = Complex();
    if (other is num) {
      final down = m.pow(other, 2);
      final newRe = (re * other) / down;
      final newIm = (im * other) / down;
      c = Complex(re: newRe, im: newIm);
    } else if (other is Complex) {
      c = this * other.conjugate();
    } else if (other is Number) {
      final down = m.pow(other.toDouble(), 2);
      final newRe = (re * other.toDouble()) / down;
      final newIm = (im * other.toDouble()) / down;
      c = Complex(re: newRe, im: newIm);
    }
    return c;
  }

  /// Gets power of this by [power]
  ///
  /// Accept only integer number in range of `-Infinite` to `Infinite`.
  Complex pow(int power) {
    if (power == 0) {
      return Complex(re: 1);
    }
    var tmpI = copy();

    for (var i = 1; i < power.abs(); i++) {
      tmpI *= this;
    }

    if (power < 0) {
      tmpI = Complex(re: 1) / tmpI;
    }

    return tmpI;
  }

  /// Gets roots of this by given [root]
  ///
  /// [root] must not be equal to zero. Otherwise [ComplexException]
  /// will be thrown.
  List<Complex> rootsOf(int root) {
    final result = <Complex>[];
    if (root == 0) {
      throw ComplexException('Еhe root of the zero degree does not exist!');
    }

    // final rootModule = m.pow(module, 1 / root);
    final rootModule = Double(module.toDouble()).rootOf(root).toDouble();

    for (var i = 0; i < root; i++) {
      final newRe = m.cos((argument + 2 * argument * i) / root) * rootModule;
      final newIm = m.sin((argument + 2 * argument * i) / root) * rootModule;
      result.add(Complex(re: newRe, im: newIm));
    }

    return result;
  }

  /// Return conjugate complex number `(1 / this)`
  Complex conjugate() {
    final denominator = m.pow(re, 2) + m.pow(im, 2);
    return Complex(re: re / denominator, im: -im / denominator);
  }

  /// Checks if this complex number have only real part
  bool isReal() => im == 0;

  /// Converts this complex number to real number if it have only real part
  num toReal() {
    if (isReal()) {
      return re;
    } else {
      throw ComplexException('This complex number have imaginary part '
          'and cannot be converted to real number!');
    }
  }

  @override
  bool operator ==(Object other) =>
      other is Complex && hashCode == other.hashCode;

  @override
  int get hashCode => hash2(re.hashCode, im.hashCode);

  @override
  Complex copy() => Complex(re: re, im: im);

  @override
  String toString() => '$re + ${im}i';
}
