/// Library that add functionality of all maths sections that don't
/// exist in `dart:math`
///
/// At the moment library have 4 sections:
///
///     1. General mathematics
///     2. Complex analysis
///     3. Discrete mathematics
///     4. Applied mathematics
///
/// Each section don't have full implementation yet.
/// See [dartdoc](https://pub.dartlang.org/documentation/extended_math/latest/)
/// for which functionality are implemented.
///
/// Sections are created according to
/// [Mathematics Subject Classification](https://en.wikipedia.org/wiki/Mathematics_Subject_Classification).
library extended_math;

export 'src/applied_mathematics/probability_theory/continuous_probability_distributions/uniform_distribution.dart';
export 'src/applied_mathematics/probability_theory/numbers_generator.dart';
export 'src/applied_mathematics/statistic/central_tendency.dart';
export 'src/applied_mathematics/statistic/dispersion.dart';
export 'src/applied_mathematics/statistic/exceptions/mean_exception.dart';
export 'src/applied_mathematics/statistic/shape_of_probability_distribution.dart';

export 'src/complex_analysis/complex.dart';

export 'src/discrete_mathematics/general_algebraic_systems/number/base/number.dart';
export 'src/discrete_mathematics/general_algebraic_systems/number/double.dart';
export 'src/discrete_mathematics/general_algebraic_systems/number/exceptions/division_by_zero_exception.dart';
export 'src/discrete_mathematics/general_algebraic_systems/number/integer.dart';

export 'src/discrete_mathematics/linear_algebra/exceptions/matrix_exception.dart';
export 'src/discrete_mathematics/linear_algebra/exceptions/tensor_exception.dart';
export 'src/discrete_mathematics/linear_algebra/exceptions/vector_exception.dart';
export 'src/discrete_mathematics/linear_algebra/tensor/base/tensor_base.dart';
export 'src/discrete_mathematics/linear_algebra/tensor/tensor1/vector.dart';
export 'src/discrete_mathematics/linear_algebra/tensor/tensor2/diagonal_matrix.dart';
export 'src/discrete_mathematics/linear_algebra/tensor/tensor2/matrix.dart';
export 'src/discrete_mathematics/linear_algebra/tensor/tensor2/square_matrix.dart';
export 'src/discrete_mathematics/linear_algebra/tensor/tensor3.dart';
export 'src/discrete_mathematics/linear_algebra/tensor/tensor4.dart';

export 'src/general/elementary_algebra/base/equation_base.dart';
export 'src/general/elementary_algebra/cubic_equation.dart';
export 'src/general/elementary_algebra/exceptions/equation_exception.dart';
export 'src/general/elementary_algebra/quadratic_equation.dart';
