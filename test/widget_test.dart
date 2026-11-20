import 'package:brain_trainer/core/difficulty.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('nextLevel', () {
    test('goes up on strong performance, capped at max', () {
      expect(nextLevel(3, 0.9, 10), 4);
      expect(nextLevel(10, 1.0, 10), 10);
    });

    test('goes down on weak performance, floored at 1', () {
      expect(nextLevel(3, 0.3, 10), 2);
      expect(nextLevel(1, 0.0, 10), 1);
    });

    test('holds in the middle band', () {
      expect(nextLevel(5, 0.65, 10), 5);
    });
  });
}
