import 'dart:math' as math;

import 'package:complex/complex.dart';
import 'package:iirjdart/src/complex_pair.dart';
import 'package:iirjdart/src/layout_base.dart';
import 'package:iirjdart/src/math_supplement.dart';
import 'package:iirjdart/src/pole_zero_pair.dart';

/// Transforms from an analogue bandpass filter to a digital bandstop filter
class BandPassTransform {
  late double _wc2;
  late double _wc;
  late double _a, _b;
  late double _a2, _b2;
  late double _ab, _ab_2;

  BandPassTransform(
      double fc, double fw, LayoutBase digital, LayoutBase analog) {
    digital.reset();

    double ww = 2 * math.pi * fw;

    // pre-calcs
    _wc2 = 2 * math.pi * fc - (ww / 2);
    _wc = _wc2 + ww;

    // what is this crap?
    if (_wc2 < 1e-8) _wc2 = 1e-8;
    if (_wc > math.pi - 1e-8) _wc = math.pi - 1e-8;

    _a = math.cos((_wc + _wc2) * 0.5) / math.cos((_wc - _wc2) * 0.5);
    _b = 1 / math.tan((_wc - _wc2) * 0.5);
    _a2 = _a * _a;
    _b2 = _b * _b;
    _ab = _a * _b;
    _ab_2 = 2 * _ab;

    int numPoles = analog.getNumPoles();
    int pairs = numPoles ~/ 2;
    for (int i = 0; i < pairs; ++i) {
      PoleZeroPair pair = analog.getPair(i);
      ComplexPair p1 = transform(pair.poles.first);
      ComplexPair z1 = transform(pair.zeros.first);

      digital.addPoleZeroConjugatePairs(p1.first, z1.first);
      digital.addPoleZeroConjugatePairs(p1.second, z1.second);
    }

    if ((numPoles & 1) == 1) {
      ComplexPair poles = transform(analog.getPair(pairs).poles.first);
      ComplexPair zeros = transform(analog.getPair(pairs).zeros.first);

      digital.addPairs(poles, zeros);
    }

    double wn = analog.normalW;
    digital.setNormal(
        2 *
            math.atan(math.sqrt(
                math.tan((_wc + wn) * 0.5) * math.tan((_wc2 + wn) * 0.5))),
        analog.normalGain);
  }

  ComplexPair transform(Complex c) {
    if (c.isInfinite) {
      return new ComplexPair(new Complex(-1), new Complex(1));
    }

    c = (Complex(1) + c) / (Complex(1) - c); // bilinear

    Complex v = new Complex(0);
    v = MathSupplement.addmul(v, 4 * (_b2 * (_a2 - 1) + 1), c);
    v += (8 * (_b2 * (_a2 - 1) - 1));
    v *= c;
    v += (4 * (_b2 * (_a2 - 1) + 1));
    v = v.sqrt();

    Complex u = v * (-1);
    u = MathSupplement.addmul(u, _ab_2, c);
    u += _ab_2;

    v = MathSupplement.addmul(v, _ab_2, c);
    v += _ab_2;

    Complex d = new Complex(0);
    d = MathSupplement.addmul(d, 2 * (_b - 1), c) + (2 * (1 + _b));

    return new ComplexPair(u / d, v / d);
  }
}
