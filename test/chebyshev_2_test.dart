import 'dart:io';

import 'package:test/test.dart';
import 'package:iirjdart/chebyshev_2.dart';

void main() {
  group("ChebyshevII Test", () {
    final double ripple = 10; // db
    final String prefix = "test/test_results/chebyshevII/";

    test("low pass", () async {
      ChebyshevII chebyshevII = new ChebyshevII();
      chebyshevII.lowPass(4, 250, 50, ripple);

      final file = File(prefix + "lp.txt");
      await file.create(recursive: true);
      final sink = file.openWrite();

      // let's do an impulse response
      for (int i = 0; i < 500; i++) {
        double v = 0;
        if (i == 10) v = 1;
        v = chebyshevII.filter(v);
        sink.writeln("$v");
      }
      expect(chebyshevII.filter(0).abs() < 1E-35, isTrue);
      expect(chebyshevII.filter(0).abs() != 0.0, isTrue);
      expect(chebyshevII.filter(0).abs() != double.nan, isTrue);

      await sink.flush();
      await sink.close();
    });

    test("bans pass", () async {
      ChebyshevII chebyshevII = new ChebyshevII();
      chebyshevII.bandPass(2, 250, 50, 5, ripple);

      final file = File(prefix + "bp.txt");
      await file.create(recursive: true);
      final sink = file.openWrite();

      // let's do an impulse response
      for (int i = 0; i < 500; i++) {
        double v = 0;
        if (i == 10) v = 1;
        v = chebyshevII.filter(v);
        sink.writeln("$v");
      }
      expect(chebyshevII.filter(0).abs() < 1E-7, isTrue);
      expect(chebyshevII.filter(0).abs() != 0.0, isTrue);
      expect(chebyshevII.filter(0).abs() != double.nan, isTrue);

      await sink.flush();
      await sink.close();
    });

    test("band stop", () async {
      ChebyshevII chebyshevII = new ChebyshevII();
      chebyshevII.bandStop(2, 250, 50, 5, ripple);

      final file = File(prefix + "bs.txt");
      await file.create(recursive: true);
      final sink = file.openWrite();

      // let's do an impulse response
      for (int i = 0; i < 500; i++) {
        double v = 0;
        if (i == 10) v = 1;
        v = chebyshevII.filter(v);
        sink.writeln("$v");
      }
      expect(chebyshevII.filter(0).abs() < 1E-10, isTrue);
      expect(chebyshevII.filter(0).abs() != 0.0, isTrue);
      expect(chebyshevII.filter(0).abs() != double.nan, isTrue);

      await sink.flush();
      await sink.close();
    });

    test("high pass", () async {
      ChebyshevII chebyshevII = new ChebyshevII();
      chebyshevII.highPass(4, 250, 50, ripple);

      final file = File(prefix + "hp.txt");
      await file.create(recursive: true);
      final sink = file.openWrite();

      // let's do an impulse response
      for (int i = 0; i < 500; i++) {
        double v = 0;
        if (i == 10) v = 1;
        v = chebyshevII.filter(v);
        sink.writeln("$v");
      }
      expect(chebyshevII.filter(0).abs() < 1E-34, isTrue);
      expect(chebyshevII.filter(0).abs() != 0.0, isTrue);
      expect(chebyshevII.filter(0).abs() != double.nan, isTrue);

      await sink.flush();
      await sink.close();
    });
  });
}
