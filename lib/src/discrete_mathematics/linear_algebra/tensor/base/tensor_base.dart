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
  TensorBase(this._dimension);

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
      Map<String, int> shape, num generator(num number)) {
    switch (shape.length) {
      case 1:
        return Vector(List<num>.generate(shape['width'], generator));
      case 2:
        final row = List<num>.generate(shape['width'], generator);
        return Matrix(List<List<num>>.generate(shape['length'], (_) => row));
      case 3:
        final depth = List<num>.generate(shape['depth'], generator);
        final width = List<List<num>>.generate(shape['width'], (_) => depth);
        return Tensor3(
            List<List<List<num>>>.generate(shape['length'], (_) => width));
      case 4:
        final depth2 = List<num>.generate(shape['depth2'], generator);
        final depth = List<List<num>>.generate(shape['depth'], (_) => depth2);
        final width =
            List<List<List<num>>>.generate(shape['width'], (_) => depth);
        return Tensor4(List<List<List<List<num>>>>.generate(
            shape['length'], (_) => width));
      default:
        return Number(generator(1));
    }
  }

  /// Holds rank of this tensor
  int _dimension;

  /// Gets dimendion of this tensor
  int get dimension => _dimension;

  /// Gets numbers count of data
  int get itemsCount;

  /// Gets data of this tensor
  Object get data;

  /// Gets shape of this tensor
  ///
  /// [shape] may contain numbers that denote count of `width`(columns),
  /// `length`(rows), `depth` and `depth2` in this order.
  Map<String, int> get shape;

  /// Reduces data to number with provided [f] reduce function
  num reduce(num f(num prev, num next));

  /// Tests if any number of data satisfies test function [f]
  bool any(bool f(num number));

  /// Tests if every number of data satisfies test function [f]
  bool every(bool f(num number));

  /// Transform each element of data and return transformed data
  TensorBase map(num f(num number));

  /// Converts this tensor to [Number] if dimension is equal to 0, otherwise throws [TensorException]
  Number toScalar() {
    if (dimension == 0) {
      return Number(data);
    } else {
      throw TensorException(
          'Tensor cannot be converted to Number, because dimension of this tensor isn\'t equal to 0!');
    }
  }

  /// Converts this tensor to [Vector] if dimension is equal to 1, otherwise throws [TensorException]
  Vector toVector() {
    if (dimension == 1) {
      return Vector(data);
    } else {
      throw TensorException(
          'Tensor cannot be converted to Vector, because dimension of this tensor isn\'t equal to 1!');
    }
  }

  /// Converts this tensor to [Matrix] if dimension is equal to 2, otherwise throws [TensorException]
  Matrix toMatrix() {
    if (dimension == 2) {
      return Matrix(data);
    } else {
      throw TensorException(
          'Tensor cannot be converted to Matrix, because dimension of this tensor isn\'t equal to 2!');
    }
  }

  /// Converts this tensor to [Tensor3] if dimension is equal to 3, otherwise throws [TensorException]
  Tensor3 toTensor3() {
    if (dimension == 3) {
      return Tensor3(data);
    } else {
      throw TensorException(
          'Tensor cannot be converted to Tensor3, because dimension of this tensor isn\'t equal to 3!');
    }
  }

  /// Converts this tensor to [Tensor4] if dimension is equal to 4, otherwise throws [TensorException]
  Tensor4 toTensor4() {
    if (dimension == 4) {
      return Tensor4(data);
    } else {
      throw TensorException(
          'Tensor cannot be converted to Tensor4, because dimension of this tensor isn\'t equal to 4!');
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
