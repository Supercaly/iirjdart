import 'dart:math' as math;
import 'package:complex/complex.dart';
import 'package:iirjdart/src/biquad_pole_state.dart';
import 'package:iirjdart/src/math_supplement.dart';
import 'package:iirjdart/src/pole_zero_pair.dart';

/// Contains the coefficients of a 2nd order digital filter with two poles and two zeros
class Biquad {
  late double _a0;
  late double _a1;
  late double _a2;
  late double _b1;
  late double _b2;
  late double _b0;

  double get a0 => _a0;
  double get a1 => _a1;
  double get a2 => _a2;
  double get b1 => _b1;
  double get b2 => _b2;
  double get b0 => _b0;

  double getA0() => _a0;
  double getA1() => _a1 * _a0;
  double getA2() => _a2 * _a0;
  double getB0() => _b0 * _a0;
  double getB1() => _b1 * _a0;
  double getB2() => _b2 * _a0;

  Complex response(double normalizedFrequency) {
    double a0 = getA0();
    double a1 = getA1();
    double a2 = getA2();
    double b0 = getB0();
    double b1 = getB1();
    double b2 = getB2();

    double w = 2 * math.pi * normalizedFrequency;
    Complex czn1 = Complex.polar(1.0, -w);
    Complex czn2 = Complex.polar(1.0, -2 * w);
    Complex ch = new Complex(1);
    Complex cbot = new Complex(1);

    Complex ct = new Complex(b0 / a0);
    Complex cb = new Complex(1);
    ct = MathSupplement.addmul(ct, b1 / a0, czn1);
    ct = MathSupplement.addmul(ct, b2 / a0, czn2);
    cb = MathSupplement.addmul(cb, a1 / a0, czn1);
    cb = MathSupplement.addmul(cb, a2 / a0, czn2);
    ch *= ct;
    cbot *= cb;

    return ch / cbot;
  }

  void setCoefficients(
      double a0, double a1, double a2, double b0, double b1, double b2) {
    _a0 = a0;
    _a1 = a1 / a0;
    _a2 = a2 / a0;
    _b0 = b0 / a0;
    _b1 = b1 / a0;
    _b2 = b2 / a0;
  }

  void setOnePole(Complex pole, Complex zero) {
    double a0 = 1;
    double a1 = -pole.real;
    double a2 = 0;
    double b0 = -zero.real;
    double b1 = 1;
    double b2 = 0;
    setCoefficients(a0, a1, a2, b0, b1, b2);
  }

  void setTwoPole(Complex pole1, Complex zero1, Complex pole2, Complex zero2) {
    double a0 = 1;
    double a1;
    double a2;

    if (pole1.imaginary != 0) {
      a1 = -2 * pole1.real;
      a2 = pole1.abs() * pole1.abs();
    } else {
      a1 = -(pole1.real + pole2.real);
      a2 = pole1.real * pole2.real;
    }

    double b0 = 1;
    double b1;
    double b2;

    if (zero1.imaginary != 0) {
      b1 = -2 * zero1.real;
      b2 = zero1.abs() * zero1.abs();
    } else {
      b1 = -(zero1.real + zero2.real);
      b2 = zero1.real * zero2.real;
    }

    setCoefficients(a0, a1, a2, b0, b1, b2);
  }

  void setPoleZeroForm(BiquadPoleState bps) {
    setPoleZeroPair(bps);
    applyScale(bps.gain);
  }

  void setIdentity() {
    setCoefficients(1, 0, 0, 1, 0, 0);
  }

  void applyScale(double scale) {
    _b0 *= scale;
    _b1 *= scale;
    _b2 *= scale;
  }

  void setPoleZeroPair(PoleZeroPair pair) {
    if (pair.isSinglePole) {
      setOnePole(pair.poles.first, pair.zeros.first);
    } else {
      setTwoPole(pair.poles.first, pair.zeros.first, pair.poles.second,
          pair.zeros.second);
    }
  }
}
