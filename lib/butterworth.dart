import 'dart:math' as math;

import 'package:complex/complex.dart';
import 'package:iirjdart/src/band_pass_transform.dart';
import 'package:iirjdart/src/band_stop_transform.dart';
import 'package:iirjdart/src/cascade.dart';
import 'package:iirjdart/src/direct_form.dart';
import 'package:iirjdart/src/high_pass_transform.dart';
import 'package:iirjdart/src/layout_base.dart';
import 'package:iirjdart/src/low_pass_transform.dart';

class _AnalogLowPass extends LayoutBase {
  int _nPoles;

  _AnalogLowPass(int nPoles)
      : _nPoles = nPoles,
        super(nPoles) {
    _nPoles = nPoles;
    setNormal(0, 1);
  }

  void design() {
    reset();
    double n2 = (2 * _nPoles).toDouble();
    int pairs = _nPoles ~/ 2;
    for (int i = 0; i < pairs; ++i) {
      Complex c =
          Complex.polar(1.0, math.pi / 2.0 + (2 * i + 1) * math.pi / n2);
      addPoleZeroConjugatePairs(c, Complex.infinity);
    }

    if ((_nPoles & 1) == 1) add(Complex(-1), Complex.infinity);
  }
}

/// Create a Butterworth filter.
///
/// Example:
/// ```dart
///   Butterworth butterworth = new Butterworth();
///   butterworth.bandPass(2,250,50,5);
/// ```
class Butterworth extends Cascade {
  /// Butterworth Low-pass filter.
  ///
  /// Params:
  /// * order - The order of the filter
  /// * sampleRate - The sampling rate of the system
  /// * cutoffFrequency - the cutoff frequency
  /// * directFormType - The filter topology. Default direct_form_II
  void lowPass(int order, double sampleRate, double cutoffFrequency,
      [int directFormType = DirectFormAbstract.direct_form_II]) {
    _AnalogLowPass analogProto = _AnalogLowPass(order);
    analogProto.design();
    LayoutBase digitalProto = LayoutBase(order);
    LowPassTransform(cutoffFrequency / sampleRate, digitalProto, analogProto);
    setLayout(digitalProto, directFormType);
  }

  /// Butterworth High-pass filter.
  ///
  /// Params:
  /// * order - Filter order (ideally only even orders)
  /// * sampleRate - Sampling rate of the system
  /// * cutoffFrequency - Cutoff of the system
  /// * directFormType - The filter topology. Default direct_form_II
  void highPass(int order, double sampleRate, double cutoffFrequency,
      [int directFormType = DirectFormAbstract.direct_form_II]) {
    _AnalogLowPass analogProto = _AnalogLowPass(order);
    analogProto.design();
    LayoutBase digitalProto = LayoutBase(order);
    HighPassTransform(cutoffFrequency / sampleRate, digitalProto, analogProto);
    setLayout(digitalProto, directFormType);
  }

  /// Butterworth Bandstop filter.
  ///
  /// Params:
  /// * order - Filter order (actual order is twice)
  /// * sampleRate - Sampling rate of the system
  /// * centerFrequency - Center frequency
  /// * widthFrequency - Width of the notch
  /// * directFormType - The filter topology. Default direct_form_II
  void bandStop(int order, double sampleRate, double centerFrequency,
      double widthFrequency,
      [int directFormType = DirectFormAbstract.direct_form_II]) {
    _AnalogLowPass analogProto = _AnalogLowPass(order);
    analogProto.design();
    LayoutBase digitalProto = LayoutBase(order * 2);
    BandStopTransform(centerFrequency / sampleRate, widthFrequency / sampleRate,
        digitalProto, analogProto);
    setLayout(digitalProto, directFormType);
  }

  /// Butterworth Bandpass filter.
  ///
  /// Params:
  /// * order - Filter order
  /// * sampleRate - Sampling rate
  /// * centerFrequency - Center frequency
  /// * widthFrequency - Width of the notch
  /// * directFormType - The filter topology. Default direct_form_II
  void bandPass(int order, double sampleRate, double centerFrequency,
      double widthFrequency,
      [int directFormType = DirectFormAbstract.direct_form_II]) {
    _AnalogLowPass analogProto = _AnalogLowPass(order);
    analogProto.design();
    LayoutBase digitalProto = LayoutBase(order * 2);
    BandPassTransform(centerFrequency / sampleRate, widthFrequency / sampleRate,
        digitalProto, analogProto);
    setLayout(digitalProto, directFormType);
  }
}
