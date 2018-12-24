/// Defines i type for complex analysis
class I {
  /// Accept [realNumber] and [imaginaryNumber] value in
  I(this.realNumber, this.imaginaryNumber);

  /// Real part of i
  double realNumber;

  /// Imaginary part of i
  double imaginaryNumber;

  @override
  String toString() => '$realNumber - $imaginaryNumber * i';
}
