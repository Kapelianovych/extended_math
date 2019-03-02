# Library that add functionality of all maths sections that don't exist in `dart:math`

__Currently this library is under heavy development! I appreciate any help in implementing any functionality of any section and hope this library will be helpful for developers
and scientists.__

Created under a MIT-style
[license](https://github.com/YevhenKap/extended_math/blob/master/LICENSE).

## Overview

At the moment library have 4 sections:

+ [General mathematics](#General-mathematics)
  + [Elementary algebra](#Elementary-algebra)
+ [Complex analysis](#Complex-analysis)
+ [Discrete mathematics](#Discrete-mathematics)
  + [General algebraic systems](#General-algebraic-systems)
    + [Number](#Number)
    + [Integer](#Integer)
    + [Double](#Double)
  + [Linear algebra](#Linear-algebra)
    + [Vector](#Vector)
    + [Matrix](#Matrix)
      + [SquareMatrix](#SquareMatrix)
      + [DiagonalMatrix](#DiagonalMatrix)
    + [Tensor3](#Tensor3)
    + [Tensor4](#Tensor4)
  + [Number theory](#Number-theory)
+ [Applied mathematics](#Applied-mathematics)
  + [Probability theory](#Probability-theory)
    + [Probability distributions](#Probability-distributions)
      + [Uniform distribution](#Uniform-distribution)
    + [Numbers generator](#Numbers-generator)
  + [Statistic](#Statistic)
    + [Central tendency](#Central-tendency)
    + [Dispersion](#Dispersion)
    + [Shape of probability distributions](#Shape-of-probability-distributions)
    + [Quantiles](#Quantiles)
      + [Quantile](#Quantile)
      + [Quartile](#Quartile)
      + [Percentile](#Percentile)

Each section don't have full implementation yet.
See here or [dartdoc](https://pub.dartlang.org/documentation/extended_math/latest/) for which functionality are implemented.

Sections are created according to [Mathematics Subject Classification](https://en.wikipedia.org/wiki/Mathematics_Subject_Classification).

### General mathematics

Study of foundations of mathematics and logic.

#### Elementary algebra

Have 2 class - `QuadraticEquation` and `CubicEquation` for solving equation expression.

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final q = QuadraticEquation(b: 2, c: 4);
  print(q); // 1x^2 + 2x + 4
  print(q.discriminant()); // -12
  print(q.calculate()); // {x1: -1.0 + -1.7320508075688772i, x2: -1.0 + 1.7320508075688772i} - all values are Complex
}
```

The same syntax available for `CubicEquation`:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final q = CubicEquation(b: 2, c: 4, d: -30);
  print(q); // 1x^3 + 2x^2 + 4x + -30
  print(q.discriminant()); // 257.8888888888889
  print(q.calculate()); // {x1: 1.2128213086426722 + 0i, x2: -1.6064106543213361 + -2.305650223617183i, x3: -1.6064106543213361 + 2.305650223617183i}
}
```

### Complex analysis

Complex analysis, traditionally known as the theory of functions of a complex variable, is the branch of mathematical analysis that investigates functions of complex numbers.

You can freely multiplicate, add, subtract, divide complex number between each other, raw numbers (`num`, `int`, `double`) and `Number`, `Integer`, `Double` equivalent in this library. Also you can use power and root functions to complex number.
Also you can compare one `Complex` number to other.

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Complex(re: 3, im: 5);
  final c2 = Complex(im: 5);
  print(c); // 3 + 5i
  print(c2); // 0 + 5i
  print(c + c2); // 3 + 10i
  print(c / c2); // 1.0 + -0.6000000000000001i
  print(c * 3); // 9 + 15i
  print(c - Double(5.1)); // -2.0999999999999996 + 5i
  print(c.module); // 5.830951894845301
  print(c.argument); // 1.0303768265243125
  print(c.pow(2)); // -16 + 30i
  print(c.rootsOf(3)); // [1.6947707432797834 + 0.606106657133791i, 0.9260370715627757 + 1.5433951192712927i, -0.26273918171949434 + 1.7806126121333576i]
}
```

### Discrete mathematics

Discrete mathematics is the study of mathematical structures that are fundamentally discrete rather than continuous.

#### General algebraic systems

A set with operations and relations defined on it. An algebraic system is one of the basic mathematical concepts and its general theory has been developed in depth.

Contains `Number`, `Integer` and `Double` analogs to Dart's types. They respond to scalar type of tensor and can be used in computations with tensors like `Vector`, `Matrix`, `Tensor3` and `Tensor4` and with each other.

##### Number

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Number(5);
  final c2 = Number(3.6);
  print(c); // 5
  print(c.rootOf(4)); // 1.495348781277992
  print(c.toComplex()); // 5 + 0i
  print(c.toDouble()); // 5.0
  print(c * c2); // 18.0
}
```

##### Integer

Contains all methods that have `Number`.

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Integer(6);
  print(c); // 6
  print(c.factorizate()); // {2}
  print(c.isPrime()); // false
}
```

##### Double

Contains all methods that have `Number`.

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Double(6.283648723694762394);
  print(c); // 6.283648723694762394
  print(c.preciseTo(4)); // 6.2837
}
```

#### Linear algebra

Linear algebra is the branch of mathematics concerning linear equations such as

a1*x1 + ⋯ + an*xn = b,
linear functions such as
(x1, …, xn) ↦ a1*x1 + … + an*xn,
and their representations through matrices and vector spaces.

All object have common type `TensorBase`. Each object have `shape`, `dimension` properties and `lerp` (constructs tensor that is linear interpolated between this tensor and other tensor) method. Also all tensors can be multiplicated (by default is used hadamard product algorithm), added, subtracted, divided (not all tensors can be divided by tensor) by each other and compared to each other.

Every tensor can transform their values with `map` method, test each value with `every`, `any` method and `reduce` tensor to some value.

##### Vector

`Vector` class have various methods to work with self:

+ computes norm (norm is a function that assigns a strictly positive length or size to each vector in a vector space—except for the zero vector, which is assigned a length of zero):

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Vector(<num>[3, 5]);
  print(c); // [3, 5]
  print(c.norm(6)); // 5.03814503530901
  print(c.euclideanNorm()); // 5.830951894845301
  print(c.maxNorm()); // 5
}
```

+ computes dot product, hadamard and cross product of two vectors:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Vector(<num>[3, 5, 4]);
  final c2 = Vector(<num>[1, 9.5, 4.78]);
  print(c.dotProduct(c2)); // 69.62
  print(c.crossProduct(c2)); // [-14.099999999999998, 10.34, 23.5]

  print(c.hadamardProduct(c2)); // [3, 47.5, 19.12]
  // or
  print(c * c2); // [3, 47.5, 19.12]
}
```

+ computes angle between two vectors, length of vector:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Vector(<num>[3, 5, 4]);
  final c2 = Vector(<num>[1, 9.5, 4.78]);
  print(c.angleBetween(c2)); // 0.3982483416991972
  print(c.angleBetween(c2, degrees: true)); // 22.817949177415088
  print(c.length); // 7.0710678118654755
}
```

+ checks for unit, orthogonal and orthonormal vectors:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Vector(<num>[3, 5, 4]);
  final c2 = Vector(<num>[1, 9.5, 4.78]);
  print(c.isUnit()); // false
  print(c.isOrthogonalTo(c2)); // false
  print(c.isOrthonormalWith(c2)); // false
}
```

##### Matrix

Matrix is a rectangular array of numbers, symbols, or expressions, arranged in rows and columns.

Matrix have various methods for work with self:

+ get, change or remove columns/rows/values:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Matrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c); // [[4, 6], [7.4, 0.687]]
  print(c.rowAt(1)); // [4, 6]
  c.replaceRow(1, <num>[6, 1]);
  print(c.rowAt(1)); // [6, 1]

  print(c.columnAt(2)); // [1, 0.687]
  c.replaceColumn(2, <num>[7, 7]);
  print(c.columnAt(2)); // [7, 7]

  print(c.itemAt(1, 2)); // 7
  c.setItem(1, 2, 56);
  print(c.itemAt(1, 2)); // 56
}
```

+ matrix, hadamard product:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Matrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  final c2 = Matrix(<List<num>>[<num>[6, 3], <num>[1.2, 9]]);
  print(c * c2); // [[24, 18], [8.88, 6.183000000000001]]
  print(c.matrixProduct(c2)); // [[31.2, 66], [45.2244, 28.383000000000003]]
}
```

+ transposition:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Matrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c.transpose()); // [[4, 7.4], [6, 0.687]]
}
```

+ computes frobenius norm:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Matrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c.frobeniusNorm()); // 10.355287007128291
}
```

+ checks for diagonal, square, identity matrix:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Matrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c.isDiagonal()); // false
  print(c.isSquare()); // true
  print(c.isIdentity()); // false
}
```

+ gets diagonals (main and collateral) as `Vector`:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Matrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c.mainDiagonal()); // [4, 0.687]
  print(c.collateralDiagonal()); // [4, 0.687]
}
```

+ gets submatrix:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Matrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c.submatrix(1, 1, 1, 1)); // [[4]]
}
```

+ perform gaussian elimination:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Matrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c.gaussian()); // [[4, 6], [0.0, -10.413000000000002]]
}
```

+ gets trace, computes rank, condition (from singular value decomposition):

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Matrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c.trace()); // 4.687
  print(c.rank()); // 2
  print(c.condition()); // 2.0977787840767292
}
```

+ computes **singular value decomposition**, **qr decomposition**:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Matrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c.svd()); // {values: [[9.347549513876027, 0.0], [0.0, 4.455927185854372]], leftVectors: [[0.689976140659287, 0.7238321112805896], [0.7238321112805896, -0.689976140659287]], rightVectors: [[0.8682769932446228, -0.49607969420454756], [0.49607969420454756, 0.8682769932446228]]}
  print(c.qr()); // {q: [[0.47551703436547405, 0.8797065135761271], [0.8797065135761271, -0.47551703436547416]], r: [[8.411896337925237, 3.4574605810196437], [0, 4.951558878847681]]}
}
```

`SquareMatrix` and `DiagonalMatrix` are separated into own classes. They have specific methods that aren't be used by `Matrix`.

###### SquareMatrix

+ computes determinant:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = SquareMatrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c.determinant()); // -41.65200000000001
}
```

+ checks if this matrix is singular, symmetric, positive (semi)definite, negative (semi)definite, indefinite, orthogonal, upper triangle, lower triangle:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = SquareMatrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c.isSingular()); // false
  print(c.isSymmetric()); // false
  print(c.isPositiveDefinite()); // false
  print(c.isPositiveSemiDefinite()); // false
  print(c.isNegativeDefinite()); // false
  print(c.isNegativeSemiDefinite()); // false
  print(c.isIndefinite()); // false
  print(c.isOrthogonal()); // false
  print(c.isUpperTriangle()); // false
  print(c.isLowerTriangle()); // false
}
```

+ inverse:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = SquareMatrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c.inverse()); // [[-0.016493805819648516, 0.14405070584845864], [0.177662537213099, -0.09603380389897243]]
}
```

+ computes **eigen decomposition**, **lu decomposition**, **cholesky decomposition**:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = SquareMatrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c.eigen()); // {9.20964828342645: [0.7550878197650748, -0.5786428772738614], -4.522648283426451: [0.6556236606792238, 0.821928287452503]}
  print(c.cholesky()); // null, because this marrix isn't positive definite
  print(c.lu()); // {upper: [[4, 6], [0.0, -10.413000000000002]], lower: [[1, 0], [1.85, 1]], pivote: [[1, 0], [0, 1]]}
}
```

+ solves linear expressions using gaussian elimination:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = SquareMatrix(<List<num>>[<num>[4, 6], <num>[7.4, 0.687]]);
  print(c.eliminate(<num>[1, 2])); // [0.2716076058772688, -0.014405070584845855] (x and y)
}
```

###### DiagonalMatrix

Have the same methods as `Matrix` and `SquareMatrix`.

##### Tensor3

Have methods that are defined in `TensorBase` class.

Also can return layer of `depth`:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Tensor3(<List<List<num>>>[
    <List<num>>[
      <num>[4, 5]],
      <List<num>>[<num>[7, 1]
    ]
  ]);
  print(c.matrixAt(1)); // [[4], [7]]
}
```

##### Tensor4

Have methods thar are defined in `TensorBase` class.

#### Number theory

This section doesn't provided yet (some functionality is in `Integer` class).

### Applied mathematics

Applied mathematics is the application of mathematical methods by different fields such as science, engineering, business, computer science, and industry.

#### Probability destributions

A probability distribution is a mathematical function that provides the probabilities of occurrence of different possible outcomes in an experiment.

##### Uniform distribution

The continuous uniform distribution is a family of symmetric probability distributions such that for each member of the family, all intervals of the same length on the distribution's support are equally probable.

+ computes density, cumulative distribution function (CDF), moments (central and common):

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = UniformDistribution(3, l: -9, u: 45);
  print(c.density()); // 0.018518518518518517
  print(c.cdf()); // 0.2222222222222222
  print(c.centralMoment(3)); // 0
  print(c.moment(3)); // 18954.0
}
```

#### Numbers generator

+ generates integer or double numbers in given range:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = NumbersGenerator();
  print(c.nextInt(10, from: 1)); // 3
  print(c.nextDouble(to: 10, from: 1)); // 4.825205248575396
}
```

Also it supports generating numbers as `Iterable`:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = NumbersGenerator();
  print(c.intIterableSync(10, 5, from: 1).take(5)); // (2, 3, 1, 3, 8)
  print(c.doubleIterableSync(10, to: 5, from: 1).take(5)); // (3.3772583795670412, 3.2489709159796276, 4.761700666599024, 4.425092938268564, 1.1353964008448607)
}
```

### Statistic

Statistics is a branch of mathematics dealing with data collection, organization, analysis, interpretation and presentation.

#### Central tendency

Class that can computes the mean value of a discrete set of numbers:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = CentralTendency(Vector(<num>[8, 5, 3]));
  print(c.arithmetic()); // 5.333333333333333
  print(c.geometric()); // 4.932424148661106
  print(c.harmonic()); // 4.556962025316456
  print(c.quadratic()); // 5.715476066494082
  print(c.maximum()); // 8
  print(c.minimum()); // 3

  // It is common algorithm for all above means
  print(c.generalized(2)); // 5.715476068195464
}
```

Also you can provide weights of numbers in set:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = CentralTendency(Vector(<num>[8, 5, 3]));
  print(c.arithmetic(weights: Vector(<num>[.25, .5, .25]))); // 5.25
  print(c.geometric(weights: Vector(<num>[.25, .5, .25]))); // 4.949232003839765
  print(c.harmonic(weights: Vector(<num>[.25, .5, .25]))); // 4.660194174757281
  print(c.quadratic()); // 5.715476066494082

  // It is common algorithm for all above means
  print(c.generalized(2)); // 5.715476068195464
}
```

+ computes mode and median:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = CentralTendency(Vector(<num>[2, 5, 3, -6, 5, 2]));
  print(c.mode()); // {2, 5}
  print(c.median()); // -1.5
}
```

#### Dispersion

Dispersion (also called variability, scatter, or spread) is the extent to which a distribution is stretched or squeezed.[1] Common examples of measures of statistical dispersion are the `variance`, `standard deviation`, and `interquartile range`:

+ gets expected value (mean), standard deviation (population and sample), variance (population and sample) of set of random numbers:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  final c = Dispersion(Vector(<num>[8, 5, 3]));
  print(c.expectedValue()); // 5.333333333333333
  print(c.std()); // 2.054804667656325
  print(t.std(type: 'sample')); // 2.516611478423583
  print(c.variance()); // 4.222222222222221
  print(t.variance(type: 'sample')); // 6.333333333333333
}
```

+ computes interquartile range (IQR):

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  const t = Vector(
    <num>[7, 7, 21, 25, 31, 31, 47, 75, 87, 115, 116, 119, 119, 155, 177]);
  print(Dispersion(t).iqr()); // 94
}
```

#### ShapeOfProbabilityDistribution

The concept of the shape of a probability distribution arises in questions of finding an appropriate distribution to use to model the statistical properties of a population, given a sample from that population.

+ computes `skewness`, `moment` and `kurtosis` (normal and excess):

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  const t = ShapeOfProbabilityDistribution(Vector(<num>[8, 5, 3]));
  print(t.moment(2)); // 4.222222222222222
  print(t.skewness()); // 0.23906314692954517
  print(t.kurtosis()); // 1.5
  print(t.kurtosis(excess: true)); // -1.5
}
```

#### Quantiles

In statistics and probability quantiles are cut points dividing the range of a probability distribution into continuous intervals with equal probabilities, or dividing the observations in a sample in the same way.

##### Quantile

Base class for all quantiles.

##### Quartile

A quartile is a type of quantile.

+ computes first, second and third quartiles:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  const t = Vector(
    <num>[7, 7, 21, 25, 31, 31, 47, 75, 87, 115, 116, 119, 119, 155, 177]);
  print(Quartile(t).calculate()); // [25, 75, 119]
  print(Quartile(t, method: 'two').calculate()); // [28.0, 75, 117.5]
  print(Quartile(t, method: 'three').calculate()); // [26.5, 75, 118.25]
}
```

##### Percentile

A percentile (or a centile) is a measure used in statistics indicating the value below which a given percentage of observations in a group of observations falls. For example, the 20th percentile is the value (or score) below which 20% of the observations may be found.

+ computes value and ordinal rank:

```dart
import 'package:extended_math/extended_math.dart';

void main() {
  const t = Vector(
    <num>[7, 7, 21, 25, 31, 31, 47, 75, 87, 115, 116, 119, 119, 155, 177]);
  final p = Percentile(t, 33);
  print(p.ordinalRank()); // 5
  print(p.value()); // 31
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/YevhenKap/extended_math/issues