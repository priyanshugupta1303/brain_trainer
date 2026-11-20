import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/quiz_engine.dart';

const _names = ['Ana', 'Ben', 'Cara', 'Dev', 'Eli', 'Fay', 'Gus', 'Hana'];

class LogicGame extends MiniGame {
  const LogicGame();

  @override
  String get id => 'logic';

  @override
  String get title => 'Logic Chains';

  @override
  String get description => 'Combine the clues to work out who is who.';

  @override
  Category get category => Category.logic;

  @override
  Widget build(BuildContext context, GameSession session) {
    final level = session.level;
    final rng = Random(session.seed);
    final count = level <= 4 ? 3 : (level <= 8 ? 4 : 5);

    final questions = List<QuizQuestion>.generate(10, (_) {
      // Hidden truth: people in order from tallest to shortest.
      final order = ([..._names]..shuffle(rng)).take(count).toList();

      // One clue per neighbouring pair, phrased two different ways, shuffled.
      final clues = <String>[];
      for (var i = 0; i < count - 1; i++) {
        final tall = order[i];
        final short = order[i + 1];
        clues.add(rng.nextBool()
            ? '$tall is taller than $short.'
            : '$short is shorter than $tall.');
      }
      clues.shuffle(rng);

      // With 4+ people, sometimes ask about two people who share no clue.
      if (count >= 4 && rng.nextInt(3) == 0) {
        final i = rng.nextInt(count - 2);
        final j = i + 2 + rng.nextInt(count - i - 2);
        return textQuestion(
          rng: rng,
          prompt: quizText(
            '${clues.join('\n')}\n\nWho is taller: ${order[i]} or ${order[j]}?',
            size: 20,
          ),
          answer: order[i],
          options: [order[i], order[j]],
        );
      }

      final askTallest = rng.nextBool();
      return textQuestion(
        rng: rng,
        prompt: quizText(
          '${clues.join('\n')}\n\nWho is the ${askTallest ? 'tallest' : 'shortest'}?',
          size: 20,
        ),
        answer: askTallest ? order.first : order.last,
        options: order,
      );
    });

    return QuizRunner(
      session: session,
      questions: questions,
      title: 'Logic Chains',
      instructions: 'Use all the clues together.',
      secondsPerQuestion: max(12, 25 - level),
    );
  }
}
