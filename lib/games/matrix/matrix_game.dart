import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/quiz_engine.dart';

class MatrixGame extends MiniGame {
  const MatrixGame();

  @override
  String get id => 'matrix';

  @override
  String get title => 'Matrix Reasoning';

  @override
  String get description => 'Every row follows the same hidden rule. Find the missing number.';

  @override
  Category get category => Category.cognitiveIntelligence;

  @override
  Widget build(BuildContext context, GameSession session) {
    final level = session.level;
    final rng = Random(session.seed);

    // Each rule combines the first two numbers of a row into the third.
    final rules = <int Function(int, int)>[
      (a, b) => a + b,
      (a, b) => a - b,
      (a, b) => a * b,
      (a, b) => 2 * a + b,
      (a, b) => a * b + a,
    ];
    final ruleCount = level <= 3 ? 2 : (level <= 7 ? 4 : 5);

    final questions = List<QuizQuestion>.generate(8, (_) {
      final ruleIndex = rng.nextInt(ruleCount);
      final rule = rules[ruleIndex];

      final rows = <List<int>>[];
      for (var r = 0; r < 3; r++) {
        final b = 2 + rng.nextInt(5);
        // Subtraction needs a > b so every cell stays positive.
        final a = ruleIndex == 1 ? b + 1 + rng.nextInt(6) : 2 + rng.nextInt(7);
        rows.add([a, b, rule(a, b)]);
      }

      return numberQuestion(
        rng: rng,
        prompt: _MatrixView(rows: rows),
        answer: rows[2][2],
        spread: 3 + level,
      );
    });

    return QuizRunner(
      session: session,
      questions: questions,
      title: 'Matrix Reasoning',
      instructions: 'Same rule in every row. What replaces the ?',
      secondsPerQuestion: max(10, 30 - level * 2),
    );
  }
}

class _MatrixView extends StatelessWidget {
  const _MatrixView({required this.rows});

  final List<List<int>> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var r = 0; r < rows.length; r++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var c = 0; c < 3; c++)
                Container(
                  width: 64,
                  height: 64,
                  margin: const EdgeInsets.all(3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0x66808080)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    (r == 2 && c == 2) ? '?' : '${rows[r][c]}',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
