import 'dart:math';

import '../../discrete_mathematics/general_algebraic_systems/number/base/number.dart';
import '../../discrete_mathematics/linear_algebra/tensor/base/tensor_base.dart';
import '../../utils/equals.dart';
import 'exceptions/mean_exception.dart';

/// Class that can compute the mean value of a discrete set of numbers
class Mean {
  /// Create instanse of [Mean] with set of positive real numbers
  Mean(TensorBase numbers) {
    if (numbers.any((e) => e <= 0)) {
      throw MeanException('All numbers in set must be greatest than zero!');
    } else {
      _set = numbers;
    }
  }

  /// Set of numbers
  TensorBase _set;

  /// Computes arithmetic mean of set numbers
  ///
  /// If [weights] isn't `null` then the weighted arithmetic mean are computed.
  /// If provided, [weights] must have the same shape as the number's set.
  double arithmetic({TensorBase weights}) {
    var set = _set.copy();
    final w = weights ?? TensorBase.generate(set.shape, (_) => 1);

    if (!isMapsEqual(set.shape, w.shape)) {
      throw ArgumentError.value(weights, 'weights',
          'Items count of weights don\'t match set of numbers!');
    }

    set *= w;

    return set.reduce((f, s) => f + s) / w.reduce((f, s) => f + s);
  }

  /// Computes geometric mean of set numbers
  ///
  /// If [weights] isn't `null` then the weighted geometric mean are computed.
  /// If provided, [weights] must have the same shape as the number's set.
  double geometric({TensorBase weights}) {
    final set = _set.copy();
    final w = weights ?? TensorBase.generate(set.shape, (_) => 1);

    if (!isMapsEqual(set.shape, w.shape)) {
      throw ArgumentError.value(weights, 'weights',
          'Items count of weights don\'t match set of numbers!');
    }

    final root = w.reduce((f, s) => f + s);
    final setList = set.toList();
    final wList = w.toList();

    for (var i = 0; i < setList.length; i++) {
      setList[i] = pow(setList[i], wList[i]);
    }

    return Number(setList.reduce((f, s) => f * s)).rootOf(root).toDouble();
  }

  /// Computes harmonic mean of set numbers
  ///
  /// If [weights] isn't `null` then the weighted harmonic mean are computed.
  /// If provided, [weights] must have the same shape as the number's set.
  double harmonic({TensorBase weights}) {
    final set = _set.copy();
    final w = weights ?? TensorBase.generate(set.shape, (_) => 1);

    if (!isMapsEqual(set.shape, w.shape)) {
      throw ArgumentError.value(weights, 'weights',
          'Items count of weights don\'t match set of numbers!');
    }

    final setList = set.toList();
    final wList = w.toList();

    for (var i = 0; i < setList.length; i++) {
      setList[i] = wList[i] / setList[i];
    }

    return w.reduce((f, s) => f + s) / setList.reduce((f, s) => f + s);
  }

  /// Computes quadratic mean of set numbers
  double quadratic() {
    final set = _set.map((v) => pow(v, 2));
    return sqrt(set.reduce((f, s) => f + s) / set.itemsCount);
  }

  /// Computes generalized (power) mean of set numbers with [degree] (p)
  double generalized(int degree) {
    if (degree == 0) {
      return geometric();
    }

    final underRoot = _set.map((n) => pow(n, degree)).reduce((f, s) => f + s) /
        _set.itemsCount;
    return Number(underRoot).rootOf(degree).toDouble();
  }

  @override
  String toString() => '$_set';
}
