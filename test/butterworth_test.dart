import 'dart:io';

import 'package:test/test.dart';
import 'package:iirjdart/butterworth.dart';

void main() {
  group("Butterworth Test", () {
    final String prefix = "test/test_results/butterworth/";

    test("low pass", () async {
      Butterworth butterworth = Butterworth();
      butterworth.lowPass(4, 250, 50);

      final file = File(prefix + "lp.txt");
      await file.create(recursive: true);
      final sink = file.openWrite();

      // let's do an impulse response
      for (int i = 0; i < 500; i++) {
        double v = 0;
        if (i == 10) v = 1;
        v = butterworth.filter(v);
        sink.writeln("$v");
      }
      expect(butterworth.filter(0).abs() < 1E-80, isTrue);
      expect(butterworth.filter(0).abs() != 0.0, isTrue);
      expect(butterworth.filter(0).abs() != double.nan, isTrue);

      await sink.flush();
      await sink.close();
    });

    test("band pass", () async {
      Butterworth butterworth = new Butterworth();
      butterworth.bandPass(2, 250, 50, 5);

      final file = File(prefix + "bp.txt");
      await file.create(recursive: true);
      final sink = file.openWrite();

      // let's do an impulse response
      for (int i = 0; i < 500; i++) {
        double v = 0;
        if (i == 10) v = 1;
        v = butterworth.filter(v);
        sink.writeln("$v");
      }
      expect(butterworth.filter(0).abs() < 1E-10, isTrue);
      expect(butterworth.filter(0).abs() != 0.0, isTrue);
      expect(butterworth.filter(0).abs() != double.nan, isTrue);

      await sink.flush();
      await sink.close();
    });

    test("band stop", () async {
      Butterworth butterworth = new Butterworth();
      butterworth.bandStop(2, 250, 50, 5);

      final file = File(prefix + "bs.txt");
      await file.create(recursive: true);
      final sink = file.openWrite();

      // let's do an impulse response
      for (int i = 0; i < 500; i++) {
        double v = 0;
        if (i == 10) v = 1;
        v = butterworth.filter(v);
        sink.writeln("$v");
      }
      expect(butterworth.filter(0).abs() < 1E-10, isTrue);
      expect(butterworth.filter(0).abs() != 0.0, isTrue);
      expect(butterworth.filter(0).abs() != double.nan, isTrue);

      await sink.flush();
      await sink.close();
    });

    test("band stop dc", () async {
      Butterworth butterworth = new Butterworth();
      butterworth.bandStop(2, 250, 50, 5);

      final file = File(prefix + "bsdc.txt");
      await file.create(recursive: true);
      final sink = file.openWrite();

      // let's do an impulse response
      for (int i = 0; i < 500; i++) {
        double v = 0;
        if (i > 10) v = 1;
        v = butterworth.filter(v);
        sink.writeln("$v");
      }
      expect(butterworth.filter(1).abs() > 0.99999999, isTrue);
      expect(butterworth.filter(1).abs() < 1.00000001, isTrue);
      expect(butterworth.filter(1).abs() != double.nan, isTrue);

      await sink.flush();
      await sink.close();
    });

    test("high pass", () async {
      Butterworth butterworth = new Butterworth();
      butterworth.highPass(4, 250, 50);

      final file = File(prefix + "hp.txt");
      await file.create(recursive: true);
      final sink = file.openWrite();

      // let's do an impulse response
      for (int i = 0; i < 500; i++) {
        double v = 0;
        if (i == 10) v = 1;
        v = butterworth.filter(v);
        sink.writeln("$v");
      }
      expect(butterworth.filter(0).abs() < 1E-80, isTrue);
      expect(butterworth.filter(0).abs() != 0.0, isTrue);
      expect(butterworth.filter(0).abs() != double.nan, isTrue);

      await sink.flush();
      await sink.close();
    });
  });
}
