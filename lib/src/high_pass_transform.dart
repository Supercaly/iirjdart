import 'dart:math' as math;
import 'package:complex/complex.dart';
import 'package:iirjdart/src/layout_base.dart';
import 'package:iirjdart/src/pole_zero_pair.dart';

/// Transforms from an analogue lowpass filter to a digital highpass filter
class HighPassTransform {
  late double f;

  HighPassTransform(double fc, LayoutBase digital, LayoutBase analog) {
    digital.reset();

    // prewarp
    f = 1.0 / math.tan(math.pi * fc);

    int numPoles = analog.getNumPoles();
    int pairs = numPoles ~/ 2;
    for (int i = 0; i < pairs; ++i) {
      PoleZeroPair pair = analog.getPair(i);
      digital.addPoleZeroConjugatePairs(
          transform(pair.poles.first), transform(pair.zeros.first));
    }

    if ((numPoles & 1) == 1) {
      PoleZeroPair pair = analog.getPair(pairs);
      digital.add(transform(pair.poles.first), transform(pair.zeros.first));
    }

    digital.setNormal(math.pi - analog.normalW, analog.normalGain);
  }

  Complex transform(Complex c) {
    if (c.isInfinite) return Complex(1, 0);

    // frequency transform
    c *= f;

    // bilinear high pass transform
    return Complex(-1) * (Complex(1) + c) / (Complex(1) - c);
  }
}
