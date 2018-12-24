/// Library that add functionality of all maths sections that don't exist in dart:math
///
/// At the moment library have 4 sections:
///
///     1. General math
///     2. Complex analysis
///     3. Linear algebra
///     4. Number theory
///
/// Each section don't have full implementation yet.
/// See [dartdoc](https://pub.dartlang.org/documentation/extended_math/latest/) for which functionality are implemented.
///
/// Sections are created according to [Mathematics Subject Classification](https://en.wikipedia.org/wiki/Mathematics_Subject_Classification).
library extended_math;

export 'src/complex_analysis/i.dart';

export 'src/general/elementary_algebra/base/equation_base.dart';
export 'src/general/elementary_algebra/cubic_equation.dart';
export 'src/general/elementary_algebra/exceptions/equation_exception.dart';
export 'src/general/elementary_algebra/quadratic_equation.dart';

export 'src/linear_algebra/exceptions/matrix_exception.dart';
export 'src/linear_algebra/exceptions/vector_exception.dart';
export 'src/linear_algebra/matrix/base/matrix_base.dart';
export 'src/linear_algebra/matrix/diagonal_matrix.dart';
export 'src/linear_algebra/matrix/matrix.dart';
export 'src/linear_algebra/matrix/square_matrix.dart';
export 'src/linear_algebra/tensor/base/tensor_base.dart';
export 'src/linear_algebra/tensor/tensor.dart';
export 'src/linear_algebra/vector/base/vector_base.dart';
export 'src/linear_algebra/vector/vector.dart';

export 'src/number_theory/composite_number.dart';
