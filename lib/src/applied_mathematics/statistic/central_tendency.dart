import 'dart:math';

import 'package:quiver/collection.dart';

import '../../discrete_mathematics/general_algebraic_systems/number/base/number.dart';
import '../../discrete_mathematics/linear_algebra/tensor/base/tensor_base.dart';
import 'exceptions/mean_exception.dart';

/// **Central tendency** (or measure of central tendency) is a central or
/// typical value for a probability distribution. It may also be called
/// a center or location of the distribution. Colloquially, measures of
/// central tendency are often called averages
class CentralTendency {
  /// Create instanse of [CentralTendency] with set of real numbers
  const CentralTendency(this._set);

  /// Set of numbers
  final TensorBase _set;

  /// Computes arithmetic mean of set numbers
  ///
  /// If [weights] isn't `null` then the weighted arithmetic mean are computed.
  /// If provided, [weights] must have the same shape as the number's set.
  num arithmetic({TensorBase? weights}) {
    if (_set.any((e) => e <= 0)) {
      throw MeanException('All numbers in set must be greatest than zero!');
    }

    var set = _set.copy();
    final w = weights ?? TensorBase.generate(set.shape, (_) => 1);

    if (!listsEqual(set.shape, w.shape)) {
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
  num geometric({TensorBase? weights}) {
    if (_set.any((e) => e <= 0)) {
      throw MeanException('All numbers in set must be greatest than zero!');
    }

    final set = _set.copy();
    final w = weights ?? TensorBase.generate(set.shape, (_) => 1);

    if (!listsEqual(set.shape, w.shape)) {
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
  num harmonic({TensorBase? weights}) {
    if (_set.any((e) => e <= 0)) {
      throw MeanException('All numbers in set must be greatest than zero!');
    }

    final set = _set.copy();
    final w = weights ?? TensorBase.generate(set.shape, (_) => 1);

    if (!listsEqual(set.shape, w.shape)) {
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
  num quadratic() => generalized(2);

  /// Computes generalized (power) mean of set numbers with [degree] (p)
  num generalized(int degree) {
    if (_set.any((e) => e <= 0)) {
      throw MeanException('All numbers in set must be greatest than zero!');
    }

    if (degree == 0) {
      return geometric();
    }

    final underRoot = _set.map((n) => pow(n, degree)).reduce((f, s) => f + s) /
        _set.itemsCount;
    return Number(underRoot).rootOf(degree).toDouble();
  }

  /// Gets minima of the set of numbers - equivalent to [generalized] with
  /// degree equal to `-Infinity`
  num minimum() {
    final list = _set.toList()..sort();
    return list.first;
  }

  /// Gets maxima of the set of numbers - equivalent to [generalized] with
  /// degree equal to `Infinity`
  num maximum() {
    final list = _set.toList()..sort();
    return list.last;
  }

  /// Gets the value separating the higher half from the lower half
  /// of a [_set]
  num median() {
    final list = _set.toList()..sort();
    final center = list.length ~/ 2;
    if (list.length % 2 == 0) {
      return (list.elementAt(center - 1) + list.elementAt(center)) / 2;
    } else {
      return list.elementAt(center);
    }
  }

  /// Gets most often appeared values of the [_set]
  Set<num> mode() {
    final list = _set.toList();
    final numbers = list.toSet();

    final result = <num>{};
    final maxCount = <num, int>{};

    for (final item in numbers) {
      maxCount[item] = list.where((e) => e == item).length;
    }

    final max = maxCount.values.toList()..sort();
    final maxEntries = maxCount.entries.where((e) => e.value == max.last);

    result.addAll(maxEntries.map((e) => e.key));
    return result;
  }

  @override
  String toString() => '$_set';
}
