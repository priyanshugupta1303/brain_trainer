import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/quiz_engine.dart';

class CodeTraceGame extends MiniGame {
  const CodeTraceGame();

  @override
  String get id => 'code_trace';

  @override
  String get title => 'Code Trace';

  @override
  String get description => 'Read a tiny program in your head and say what it prints.';

  @override
  Category get category => Category.coding;

  @override
  Widget build(BuildContext context, GameSession session) {
    final level = session.level;
    final rng = Random(session.seed);

    final questions = List<QuizQuestion>.generate(8, (_) {
      final (code, answer) = _snippet(rng, level);
      return numberQuestion(
        rng: rng,
        prompt: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0x1F808080),
                borderRadius: BorderRadius.circular(12),
              ),
              child: quizText(code, size: 20, mono: true, align: TextAlign.left),
            ),
            const SizedBox(height: 12),
            quizText('What does it print?', size: 18),
          ],
        ),
        answer: answer,
        spread: 4 + level ~/ 2,
      );
    });

    return QuizRunner(
      session: session,
      questions: questions,
      title: 'Code Trace',
      instructions: 'Follow the program line by line.',
      secondsPerQuestion: max(12, 30 - level * 2),
    );
  }
}

(String, int) _snippet(Random rng, int level) {
  final kinds = level <= 3 ? 2 : (level <= 6 ? 4 : 6);

  switch (rng.nextInt(kinds)) {
    case 0:
      {
        final a = 2 + rng.nextInt(8);
        final b = 2 + rng.nextInt(8);
        return ('x = $a\nx = x + $b\nprint x', a + b);
      }
    case 1:
      {
        final a = 2 + rng.nextInt(8);
        final b = 2 + rng.nextInt(8);
        final c = 2 + rng.nextInt(3);
        return ('x = $a\nx = x + $b\nx = x * $c\nprint x', (a + b) * c);
      }
    case 2:
      {
        final a = 1 + rng.nextInt(9);
        final n = 3 + rng.nextInt(4);
        final k = 2 + rng.nextInt(4);
        return ('x = $a\nrepeat $n times:\n  x = x + $k\nprint x', a + n * k);
      }
    case 3:
      {
        final a = 3 + rng.nextInt(10);
        final t = 3 + rng.nextInt(10);
        final b = 2 + rng.nextInt(6);
        final result = a > t ? a - b : a + b;
        return (
          'x = $a\nif x > $t:\n  x = x - $b\nelse:\n  x = x + $b\nprint x',
          result,
        );
      }
    case 4:
      {
        final n = 6 + rng.nextInt(7);
        var total = 0;
        for (var i = 1; i <= n; i++) {
          if (i.isEven) total += i;
        }
        return (
          'total = 0\nfor i in 1..$n:\n  if i is even:\n    total = total + i\nprint total',
          total,
        );
      }
    default:
      {
        final n = 3 + rng.nextInt(3);
        var x = 1;
        for (var i = 0; i < n; i++) {
          x = x * 2;
          x = x - 1;
        }
        return ('x = 1\nrepeat $n times:\n  x = x * 2\n  x = x - 1\nprint x', x);
      }
  }
}
