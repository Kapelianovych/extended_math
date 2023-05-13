import 'package:quiver/collection.dart';

import '../../../../mixins/copyable_mixin.dart';
import '../../../general_algebraic_systems/number/base/number.dart';
import '../../exceptions/tensor_exception.dart';
import '../tensor1/vector.dart';
import '../tensor2/matrix.dart';
import '../tensor3.dart';
import '../tensor4.dart';

/// Base class for tensors
abstract class TensorBase with CopyableMixin<TensorBase> {
  /// Creates instanse of TensorBase with dimensions
  const TensorBase(this.dimension);

  /// Generates tensor for specific [shape] and [generator]
  ///
  /// [shape] may contain numbers that denote count of `width`(columns),
  /// `length`(rows), `depth` and `depth2` in this order.
  ///
  /// Example:
  ///
  /// - [1] -> `Vector`
  /// - [2, 3] -> `Matrix` with 2 rows and 3 columns
  /// - [4, 2, 5] -> `Tensor3` with 4 width, 2 length and 5 depth
  factory TensorBase.generate(
      List<int> shape, num Function(num number) generator) {
    switch (shape.length) {
      case 1:
        return Vector(List<num>.generate(shape[0], generator));
      case 2:
        final row = List<num>.generate(shape[1], generator);
        return Matrix(List<List<num>>.generate(shape[0], (_) => row));
      case 3:
        final depth = List<num>.generate(shape[2], generator);
        final width = List<List<num>>.generate(shape[1], (_) => depth);
        return Tensor3(
            List<List<List<num>>>.generate(shape[0], (_) => width));
      case 4:
        final depth2 = List<num>.generate(shape[3], generator);
        final depth = List<List<num>>.generate(shape[2], (_) => depth2);
        final width =
            List<List<List<num>>>.generate(shape[1], (_) => depth);
        return Tensor4(List<List<List<List<num>>>>.generate(
            shape[0], (_) => width));
      default:
        return Number(generator(1));
    }
  }

  /// Holds rank of this tensor
  final int dimension;

  /// Gets numbers count of data
  int get itemsCount;

  /// Gets data of this tensor
  Object get data;

  /// Gets shape of this tensor
  ///
  /// [shape] may contain numbers that denote count of entries in each
  /// dimension of the tensor, with shape[0] being the count for the first
  /// dimension shape[1] in the second and so on.
  List<int> get shape;

  /// Reduces data to number with provided [f] reduce function
  num reduce(num Function(num prev, num next) f);

  /// Tests if any number of data satisfies test function [f]
  bool any(bool Function(num number) f);

  /// Tests if every number of data satisfies test function [f]
  bool every(bool Function(num number) f);

  /// Transform each element of data and return transformed data
  TensorBase map(num Function(num number) f);

  /// Converts this tensor to [Number] if dimension is equal to 0,
  /// otherwise throws [TensorException]
  Number toScalar() {
    if (dimension == 0) {
      return Number(data as num);
    } else {
      throw TensorException('Tensor cannot be converted to Number, because '
          'dimension of this tensor isn\'t equal to 0!');
    }
  }

  /// Converts this tensor to [Vector] if dimension is equal to 1,
  /// otherwise throws [TensorException]
  Vector toVector() {
    if (dimension == 1) {
      return Vector(data as List<num>);
    } else {
      throw TensorException('Tensor cannot be converted to Vector, because '
          'dimension of this tensor isn\'t equal to 1!');
    }
  }

  /// Converts this tensor to [Matrix] if dimension is equal to 2,
  /// otherwise throws [TensorException]
  Matrix toMatrix() {
    if (dimension == 2) {
      return Matrix(data as List<List<num>>);
    } else {
      throw TensorException('Tensor cannot be converted to Matrix, because '
          'dimension of this tensor isn\'t equal to 2!');
    }
  }

  /// Converts this tensor to [Tensor3] if dimension is equal to 3,
  /// otherwise throws [TensorException]
  Tensor3 toTensor3() {
    if (dimension == 3) {
      return Tensor3(data as List<List<List<num>>>);
    } else {
      throw TensorException('Tensor cannot be converted to Tensor3, because '
          'dimension of this tensor isn\'t equal to 3!');
    }
  }

  /// Converts this tensor to [Tensor4] if dimension is equal to 4,
  /// otherwise throws [TensorException]
  Tensor4 toTensor4() {
    if (dimension == 4) {
      return Tensor4(data as List<List<List<List<num>>>>);
    } else {
      throw TensorException('Tensor cannot be converted to Tensor4, because '
          'dimension of this tensor isn\'t equal to 4!');
    }
  }

  /// Constructs tensor that is linear interpolated between this
  /// tensor and [other]
  ///
  /// Constructs new data points within the range of a discrete set
  /// of known data points [a] (alpha) may be in range from 0 to 1
  /// inclusively. Otherwise throws [TensorException].
  TensorBase lerp(TensorBase other, double a) {
    if (dimension != other.dimension && !listsEqual(shape, other.shape)) {
      throw ArgumentError('Tensors aren\'t equals!');
    }

    if (a >= 0 && a <= 1) {
      return copy() * (1 - a) + other * a;
    } else {
      throw TensorException(
          'Calculated tensor isn\'t within the range of a discrete '
          'set of known data points (tensors).\n'
          'a ($a) is out of range [0, 1]!');
    }
  }

  /// Converts tensor to one dimensional list
  List<num> toList();

  /// Performs addition this and [other]
  TensorBase operator +(covariant Object other);

  /// Performs subtraction [other] from this
  TensorBase operator -(covariant Object other);

  /// Unary minus
  TensorBase operator -();

  /// Multiplies this by [other]
  ///
  /// Hadamard product algorithm is used.
  TensorBase operator *(covariant Object other);

  /// Divides this by [other]
  TensorBase operator /(covariant Object other);

  @override
  bool operator ==(Object other) =>
      other is TensorBase && hashCode == other.hashCode;

  @override
  int get hashCode => data.hashCode;
}
