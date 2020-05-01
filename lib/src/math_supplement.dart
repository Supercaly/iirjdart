
import 'dart:math' as math;

import 'package:complex/complex.dart';

/// Useful math functions which come back over and over again
class MathSupplement {

  static double doubleLn10 =2.3025850929940456840179914546844;

  static Complex solveQuadratic1(double a, double b, double c) {
    return (Complex(-b) * (Complex(b * b - 4 * a * c, 0)).sqrt()) / (2.0 * a);
  }

  static Complex solveQuadratic2(double a, double b, double c) {
    return (Complex(-b) - (Complex(b * b - 4 * a * c, 0)).sqrt()) / (2.0 * a);
  }

  static Complex adjustImag(Complex c) {
    if (c.imaginary.abs() < 1e-30)
      return Complex(c.real, 0);
    else
      return c;
  }

  static Complex addmul(Complex c, double v, Complex c1) =>
    Complex(c.real + v * c1.real, c.imaginary + v * c1.imaginary);

  static Complex recip(Complex c) {
    double n = 1.0 / (c.abs() * c.abs());
    return Complex(n * c.real, n * c.imaginary);
  }

  static double asinh(double x) => math.log(x + math.sqrt(x * x + 1));

  static double acosh(double x) => math.log(x + math.sqrt(x * x - 1));

}