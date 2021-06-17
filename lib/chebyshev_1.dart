import 'dart:math' as math;

import 'package:complex/fastmath.dart';
import 'package:complex/complex.dart';
import 'package:iirjdart/src/band_pass_transform.dart';
import 'package:iirjdart/src/band_stop_transform.dart';
import 'package:iirjdart/src/cascade.dart';
import 'package:iirjdart/src/direct_form.dart';
import 'package:iirjdart/src/high_pass_transform.dart';
import 'package:iirjdart/src/layout_base.dart';
import 'package:iirjdart/src/low_pass_transform.dart';
import 'package:iirjdart/src/math_supplement.dart';

class _AnalogLowPass extends LayoutBase {
  int nPoles;

  _AnalogLowPass(int _nPoles)
      : nPoles = _nPoles,
        super(_nPoles);

  void design(double rippleDb) {
    reset();

    double eps = math
        .sqrt(1.0 / math.exp(-rippleDb * 0.1 * MathSupplement.doubleLn10) - 1);
    double v0 = MathSupplement.asinh(1 / eps) / nPoles;
    double sinhV0 = -sinh(v0);
    double coshV0 = cosh(v0);

    double n2 = 2.0 * nPoles;
    int pairs = nPoles ~/ 2;
    for (int i = 0; i < pairs; ++i) {
      int k = 2 * i + 1 - nPoles;
      double a = sinhV0 * math.cos(k * math.pi / n2);
      double b = coshV0 * math.sin(k * math.pi / n2);

      addPoleZeroConjugatePairs(Complex(a, b), Complex(double.infinity));
    }

    if ((nPoles & 1) == 1) {
      add(Complex(sinhV0, 0), Complex(double.infinity));
      setNormal(0, 1);
    } else {
      setNormal(0, math.pow(10, -rippleDb / 20.0).toDouble());
    }
  }
}

/// Create a ChebyshevI filter.
///
/// Example:
/// ```dart
///   ChebyshevI chebyshev = new ChebyshevI();
///   chebyshev.bandPass(2,250,50,5);
/// ```
class ChebyshevI extends Cascade {
  /// ChebyshevI Lowpass filter with custom topology
  ///
  /// Param:
  /// * order - The order of the filter
  /// * sampleRate - The sampling rate of the system
  /// * cutoffFrequency - The cutoff frequency
  /// * rippleDb - pass-band ripple in decibel sensible value: 1dB
  /// * directFormType - The filter topology. Default dirrect_form_II
  void lowPass(
      int order, double sampleRate, double cutoffFrequency, double rippleDb,
      [int directFormType = DirectFormAbstract.direct_form_II]) {
    _AnalogLowPass analogProto = _AnalogLowPass(order);
    analogProto.design(rippleDb);
    LayoutBase digitalProto = LayoutBase(order);
    LowPassTransform(cutoffFrequency / sampleRate, digitalProto, analogProto);
    setLayout(digitalProto, directFormType);
  }

  /// ChebyshevI Lowpass filter and custom filter topology
  ///
  /// Param:
  /// * order - The order of the filter
  /// * sampleRate - The sampling rate of the system
  /// * cutoffFrequency - The cutoff frequency
  /// * rippleDb - pass-band ripple in decibel sensible value: 1dB
  /// * directFormType - The filter topology. Default direct_form_II
  void highPass(
      int order, double sampleRate, double cutoffFrequency, double rippleDb,
      [int directFormType = DirectFormAbstract.direct_form_II]) {
    _AnalogLowPass analogProto = _AnalogLowPass(order);
    analogProto.design(rippleDb);
    LayoutBase digitalProto = LayoutBase(order);
    HighPassTransform(cutoffFrequency / sampleRate, digitalProto, analogProto);
    setLayout(digitalProto, directFormType);
  }

  /// Bandstop filter with custom topology
  ///
  /// Params:
  /// * order - Filter order (actual order is twice)
  /// * sampleRate - Samping rate of the system
  /// * centerFrequency - Center frequency
  /// * widthFrequency - Width of the notch
  /// * rippleDb - pass-band ripple in decibel sensible value: 1dB
  /// * directFormType - The filter topology. Default direct_form_II
  void bandStop(int order, double sampleRate, double centerFrequency,
      double widthFrequency, double rippleDb,
      [int directFormType = DirectFormAbstract.direct_form_II]) {
    _AnalogLowPass analogProto = _AnalogLowPass(order);
    analogProto.design(rippleDb);
    LayoutBase digitalProto = LayoutBase(order * 2);
    BandStopTransform(centerFrequency / sampleRate, widthFrequency / sampleRate,
        digitalProto, analogProto);
    setLayout(digitalProto, directFormType);
  }

  /// Bandpass filter with custom topology
  ///
  /// Param:
  /// * order - Filter order
  /// * sampleRate - Sampling rate
  /// * centerFrequency - Center frequency
  /// * widthFrequency - Width of the notch
  /// * rippleDb - pass-band ripple in decibel sensible value: 1dB
  /// * directFormType - The filter topology. Default direct_form_II
  void bandPass(int order, double sampleRate, double centerFrequency,
      double widthFrequency, double rippleDb,
      [int directFormType = DirectFormAbstract.direct_form_II]) {
    _AnalogLowPass analogProto = _AnalogLowPass(order);
    analogProto.design(rippleDb);
    LayoutBase digitalProto = LayoutBase(order * 2);
    BandPassTransform(centerFrequency / sampleRate, widthFrequency / sampleRate,
        digitalProto, analogProto);
    setLayout(digitalProto, directFormType);
  }
}
