import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/quiz_engine.dart';

class CalculationGame extends MiniGame {
  const CalculationGame();

  @override
  String get id => 'calculation';

  @override
  String get title => 'Quick Calc';

  @override
  String get description => 'Solve the sum and pick the right answer before time runs out.';

  @override
  Category get category => Category.calculation;

  @override
  Widget build(BuildContext context, GameSession session) {
    final level = session.level;
    final rng = Random(session.seed);

    final questions = List<QuizQuestion>.generate(12, (_) {
      final (text, answer) = _problem(rng, level);
      return numberQuestion(
        rng: rng,
        prompt: quizText(text, size: 44, weight: FontWeight.w700),
        answer: answer,
        spread: 6 + level,
      );
    });

    return QuizRunner(
      session: session,
      questions: questions,
      title: 'Quick Calc',
      instructions: 'Pick the correct result.',
      secondsPerQuestion: max(6, 15 - level),
    );
  }
}

/// Harder levels add bigger numbers, then × and ÷, then mixed expressions.
(String, int) _problem(Random rng, int level) {
  final scale = 10 + level * 10;
  final kinds = level <= 2 ? 2 : (level <= 5 ? 3 : 5);

  switch (rng.nextInt(kinds)) {
    case 0:
      {
        final a = 5 + rng.nextInt(scale);
        final b = 5 + rng.nextInt(scale);
        return ('$a + $b', a + b);
      }
    case 1:
      {
        final a = 10 + rng.nextInt(scale);
        final b = 5 + rng.nextInt(a - 4); // 5..a
        return ('$a − $b', a - b);
      }
    case 2:
      {
        final a = 2 + rng.nextInt(8);
        final b = 2 + rng.nextInt(level < 6 ? 8 : 11);
        return ('$a × $b', a * b);
      }
    case 3:
      {
        final b = 2 + rng.nextInt(8);
        final q = 2 + rng.nextInt(11);
        return ('${b * q} ÷ $b', q);
      }
    default:
      {
        final a = 5 + rng.nextInt(26);
        final b = 2 + rng.nextInt(8);
        final c = 2 + rng.nextInt(8);
        return ('$a + $b × $c', a + b * c);
      }
  }
}
