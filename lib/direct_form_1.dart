
import 'package:iirjdart/biquad.dart';
import 'package:iirjdart/direct_form.dart';

/// Implementation of a Direct Form I filter with its states. The coefficients
/// are supplied from the outside.
class DirectFormI extends DirectFormAbstract {

  double m_x2; // x[n-2]
  double m_y2; // y[n-2]
  double m_x1; // x[n-1]
  double m_y1; // y[n-1]

  DirectFormI() {
    reset();
  }

  @override
  void reset() {
    m_x1 = 0;
    m_x2 = 0;
    m_y1 = 0;
    m_y2 = 0;
  }

  @override
  double process1(double _in, Biquad s) {
    double out = s.b0
    * _in + s.b1 * m_x1 + s.b2 * m_x2
    - s.a1 * m_y1 - s.a2 * m_y2;
    m_x2 = m_x1;
    m_y2 = m_y1;
    m_x1 = _in;
    m_y1 = out;

    return
    out;
  }
}