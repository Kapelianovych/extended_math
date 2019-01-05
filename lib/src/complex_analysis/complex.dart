import 'dart:math' as m;

import 'package:quiver/core.dart';

import '../discrete_mathematics/linear_algebra/vector/vector.dart';
import 'exceptions/complex_exception.dart';

/// Defines type for number i of complex analysis
class Complex {
  /// Accept [re] and [im] value in
  Complex({this.re = 0, this.im = 0});

  /// Creates complex number from real number
  Complex.toComplex(this.re);

  /// Real part of i
  num re = 0;

  /// Imaginary part of i
  num im = 0;

  /// Module of this
  num get module => Vector(<num>[re, im]).length;

  /// Argument of this (angle of the radius Oz, where z is this)
  num get argument => Vector(<num>[re, im]).angleBetween(Vector(<int>[1, 0]));

  /// Add this to another [i]
  Complex operator +(Object i) {
    Complex c;
    if (i is num) {
      c = Complex(re: re + i, im: im);
    } else if (i is Complex) {
      c = Complex(re: re + i.re, im: im + i.im);
    }
    return c;
  }

  /// Subtract [i] from this
  Complex operator -(Object i) {
    Complex c;
    if (i is Complex) {
      c = this + -i;
    } else if (i is num) {
      c = Complex(re: re - i, im: im);
    }
    return c;
  }

  /// Unary minus of this
  Complex operator -() => Complex(re: -re, im: -im);

  /// Multiply this i by another [i]
  Complex operator *(Complex i) {
    final newRe = re * i.re + im * i.im * -1;
    final newIm = re * i.im + im * i.re;
    return Complex(re: newRe, im: newIm);
  }

  /// Divide this i by another [i]
  Complex operator /(Complex i) {
    final down = m.pow(i.re, 2) + m.pow(i.im, 2);
    final newRe = (re * i.re + im * i.im) / down;
    final newIm = (im * i.re - re * i.im) / down;
    return Complex(re: newRe, im: newIm);
  }

  /// Gets power of this by [power]
  ///
  /// Accept only integer number in range of `-Infinite` to `Infinite` except zero.
  Complex pow(int power) {
    if (power == 0) {
      return Complex.toComplex(1);
    }
    var tmpI = this;

    // реалізувати для дробів
    for (var i = 1; i < power.abs(); i++) {
      tmpI *= this;
    }

    if (power < 0) {
      tmpI = Complex.toComplex(1) / tmpI;
    }

    return tmpI;
  }

  /// Gets root of this by given [root]
  ///
  /// [root] must not be equal to zero. Otherwise [ComplexException] will be thrown.
  Complex rootOf(int root) {
    if (root == 0) {
      throw ComplexException('Еhe root of the zero degree does not exist!');
    }

    final rootModule = m.pow(module, 1 / root);
    final newRe = m.cos(argument / root) * rootModule;
    final newIm = m.sin(argument / root) * rootModule;

    return Complex(re: newRe, im: newIm);
  }

  @override
  bool operator ==(Object other) =>
      other is Complex && hashCode == other.hashCode;

  @override
  int get hashCode => hash2(re.hashCode, im.hashCode);

  @override
  String toString() => '$re + $im * i';
}
