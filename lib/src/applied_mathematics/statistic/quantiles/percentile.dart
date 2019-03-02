import '../../../discrete_mathematics/linear_algebra/tensor/base/tensor_base.dart';
import '../exceptions/quantile_exception.dart';
import 'base/quantile.dart';

/// A percentile (or a centile) is a measure used in statistics indicating 
/// the value below which a given percentage of observations in a group 
/// of observations falls
class Percentile extends Quantile {
  /// Creates [Percentile] with [data] and [number] as kth-percentile
  /// 
  /// [number] mus be in range from 0 to 100, otherwise [QuantileException]
  /// is thrown.
  Percentile(this.data, this.number) : super(100) {
    if (number < 0 || number > 100) {
      throw QuantileException('$number must be in range from 0 to 100!');
    }
  }

  /// Holds data set
  final TensorBase data;

  /// Gets sorted [data] in ascending order
  List<num> get sortedData {
    final sortedData = data.toList()
      ..sort();
    return sortedData;
  }

  /// Holds number that define `kth-percentile`
  int number;

  /// Computes ordinal rank of this [Percentile]
  int ordinalRank() => ((number / 100) * data.itemsCount).ceil();
  
  /// Gets  the smallest value in the list such that no more than 
  /// [number] percent of the data is strictly less than the value and at 
  /// least [number] percent of the data is less than or equal to that value
  /// 
  /// Calculated by the nearest-rank method.
  num value() => sortedData[ordinalRank()];
}