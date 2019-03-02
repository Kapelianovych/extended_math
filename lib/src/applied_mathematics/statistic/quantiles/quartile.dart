import '../../../discrete_mathematics/linear_algebra/tensor/base/tensor_base.dart';
import '../../../discrete_mathematics/linear_algebra/tensor/tensor1/vector.dart';
import '../central_tendency.dart';
import 'base/quantile.dart';

/// A quartile is a type of quantile (4-sized [Quantile])
class Quartile extends Quantile {
  /// Construct [Quartile] with [data] and [method] variant to calculating
  /// quartiles
  Quartile(this.data, {this.method = 'one'}) : super(4);

  /// Holds data set
  final TensorBase data;

  /// Method to compute quartiles
  /// 
  /// [May have 3 values](https://en.wikipedia.org/wiki/Quartile):
  /// 
  ///     1. one (default)
  ///     1. two
  ///     1. three
  String method;

  /// Gets `Q1` corresponding to [method]
  num get first => calculate()[0];

  /// Gets `Q2` corresponding to [method]
  num get second => calculate()[1];

  /// Gets `Q3` corresponding to [method]
  num get third => calculate()[2];

  /// Calculate `Q1`, `Q2` and `Q3` corresponding to [method]
  List<num> calculate() {
    final listData = data.toList();
    final result = <num>[CentralTendency(data).median()];

    switch (method) {
      case 'two':
        return _methodOneOrTwo();
      case 'three':
        final isEven = listData.length % 2 == 0;
        if (isEven) {
          return _methodOneOrTwo();
        }

        final isFourPlusOne = (listData.length - 1) % 4 == 0;
        final equalIndex = isFourPlusOne 
          ? (listData.length - 1) ~/ 4 
          : (listData.length - 3) ~/ 4;
        num first = 0;
        num third = 0;

        if (isFourPlusOne) {
          first = listData[equalIndex - 1] * .75 
            + listData[equalIndex] * .25;
          third = listData[3 * equalIndex] * .25 
            + listData[3 * equalIndex + 1] * .75;
        } else {
          first = listData[equalIndex] * .75 
            + listData[equalIndex + 1] * .25;
          third = listData[3 * equalIndex + 1] * .25 
            + listData[3 * equalIndex + 2] * .75;
        }

        result
          ..insert(0, first)
          ..add(third);

        return result;
      default:
        return _methodOneOrTwo();
    }
  }

  /// Computes values for first and second [method]
  List<num> _methodOneOrTwo() {
    final listData = data.toList();
    final result = <num>[CentralTendency(data).median()];

    final half = listData.length / 2;

    final first = listData
          .sublist(0, method == 'one' ? half.floor() : half.ceil());
    final third = listData
          .sublist(method == 'one' ? half.ceil() : half.floor());
    result
      ..insert(0, CentralTendency(
        Vector(first)).median()
      )
      ..add(CentralTendency(
        Vector(third)).median());
    return result;
  }
}
