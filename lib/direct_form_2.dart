
import 'package:iirjdart/biquad.dart';
import 'package:iirjdart/direct_form.dart';

/// Implementation of a Direct Form II filter with its states. The coefficients
/// are supplied from the outside.
class DirectFormII extends DirectFormAbstract {

  double m_v1; // v[-1]
  double m_v2; // v[-2]

  DirectFormII() {
    reset();
  }

  @override
  void reset() {
    m_v1 = 0;
    m_v2 = 0;
  }

  @override
  double process1(double _in, Biquad s) {
    if (s != null) {
      double w = _in
      -s.a1 * m_v1 - s.a2 * m_v2;
      double out = s.b0 * w + s.b1 * m_v1 + s.b2 * m_v2;

      m_v2 = m_v1;
      m_v1 = w;

      return out;
    } else {
      return _in;
    }
  }
}