import 'dart:io';

import 'package:test/test.dart';
import 'package:iirjdart/chebyshev_1.dart';

void main() {
  group("ChebushevI Test", () {
    final double ripple = 0.1; // db
    final String prefix = "test/test_results/chebyshevI/";

    test("low pass", () async {
      ChebyshevI chebyshevI = new ChebyshevI();
      chebyshevI.lowPass(4, 250, 50, ripple);

      final file = File(prefix + "lp.txt");
      await file.create(recursive: true);
      final sink = file.openWrite();

      // let's do an impulse response
      for (int i = 0; i < 500; i++) {
        double v = 0;
        if (i == 10) v = 1;
        v = chebyshevI.filter(v);
        sink.writeln("$v");
      }
      expect(chebyshevI.filter(0).abs() < 1E-49, isTrue);
      expect(chebyshevI.filter(0).abs() != 0.0, isTrue);
      expect(chebyshevI.filter(0).abs() != double.nan, isTrue);

      await sink.flush();
      await sink.close();
    });

    test("band pass", () async {
      ChebyshevI chebyshevI = new ChebyshevI();
      chebyshevI.bandPass(2, 250, 50, 5, ripple);

      final file = File(prefix + "bp.txt");
      await file.create(recursive: true);
      final sink = file.openWrite();

      // let's do an impulse response
      for (int i = 0; i < 500; i++) {
        double v = 0;
        if (i == 10) v = 1;
        v = chebyshevI.filter(v);
        sink.writeln("$v");
      }
      expect(chebyshevI.filter(0).abs() < 1E-15, isTrue);
      expect(chebyshevI.filter(0).abs() != 0.0, isTrue);
      expect(chebyshevI.filter(0).abs() != double.nan, isTrue);

      await sink.flush();
      await sink.close();
    });

    test("band stop", () async {
      ChebyshevI chebyshevI = new ChebyshevI();
      chebyshevI.bandStop(2, 250, 50, 5, ripple);

      final file = File(prefix + "bs.txt");
      await file.create(recursive: true);
      final sink = file.openWrite();

      // let's do an impulse response
      for (int i = 0; i < 500; i++) {
        double v = 0;
        if (i == 10) v = 1;
        v = chebyshevI.filter(v);
        sink.writeln("$v");
      }
      expect(chebyshevI.filter(0).abs() < 1E-5, isTrue);
      expect(chebyshevI.filter(0).abs() != 0.0, isTrue);
      expect(chebyshevI.filter(0).abs() != double.nan, isTrue);

      await sink.flush();
      await sink.close();
    });

    test("high pass", () async {
      ChebyshevI chebyshevI = new ChebyshevI();
      chebyshevI.highPass(4, 250, 50, ripple);

      final file = File(prefix + "hp.txt");
      await file.create(recursive: true);
      final sink = file.openWrite();

      // let's do an impulse response
      for (int i = 0; i < 500; i++) {
        double v = 0;
        if (i == 10) v = 1;
        v = chebyshevI.filter(v);
        sink.writeln("$v");
      }
      expect(chebyshevI.filter(0).abs() < 1E-44, isTrue);
      expect(chebyshevI.filter(0).abs() != 0.0, isTrue);
      expect(chebyshevI.filter(0).abs() != double.nan, isTrue);

      await sink.flush();
      await sink.close();
    });
  });
}
